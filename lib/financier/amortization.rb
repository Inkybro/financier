module Financier
  class Amortization
    class << self
      def payment(principal, rate, periods)
        principal, rate, periods = [D(principal.to_s), D(rate.to_s), D(periods.to_s)]

        return -(principal / periods).round(2) if rate.zero?

        -(principal * (rate + (rate / ((1 + rate) ** periods - 1)))).round(2)
      end

      def interest(principal, rate)
        (D(principal.to_s) * D(rate.to_s))
      end
    end

    #attr_reader :principal, :rate, :closing_date, :first_payment_due
    attr_reader :payment, :closing_date, :first_payment_due, :ledger

    def initialize(principal, rate, closing_date: nil, first_payment_due: nil)
      @principal = Flt::DecNum.new(principal.to_s)
      @rate = rate

      self.closing_date = closing_date || Time.now
      self.first_payment_due = first_payment_due || (@closing_date + 30.days)

      #@periods = rate.duration
      #@period = 0

      compute
    end

    def balance
      return unless @ledger
      @ledger.balance
    end

    def payments
      return unless @ledger
      @ledger.debits
    end

    def interest
      return unless @ledger
      @ledger.credits[1..(@ledger.credits.length - 1)]
    end

    def closing_date=(value)
      @closing_date = Date[value]
    end

    def first_payment_due=(value)
      @first_payment_due = Date[value]
    end

    def amortize
      @payment = Amortization.payment(@principal + interim_interest, @rate.monthly, @rate.duration)
      @ledger = Ledger.new(@principal)

      current_date = @first_payment_due

      @rate.duration.to_i.times do |period|
        break if @ledger.balance.zero?

        int = @ledger.balance * @rate.monthly
        int += interim_interest * (1 + @rate.monthly) if period === 0
        @ledger << Transaction.new(int.round(2), current_date)

        pmt = @payment.abs <= @ledger.balance ? @payment : -@ledger.balance
        @ledger << Transaction.new(pmt, current_date)

        current_date += 1.month
      end

      @ledger.debits.last.amount -= @ledger.balance unless @ledger.balance.zero?
    end

    def compute
      amortize
    end

    def schedule
      @schedule = {}

      @schedule[closing_date] = {
        payment: 0.0,
        interest: 0.0,
        principal: 0.0,
        balance: @principal.round(2).to_f
      }

      payments.each_with_index do |payment, index|
        interest = self.interest[index]

        pmt = payment.amount.abs.round(2).to_f
        int = interest.amount.abs.round(2).to_f
        princ = (pmt - int).round(2).to_f
        bal = @ledger.balance(before: payment.date + 1.day).round(2).to_f

        @schedule[payment.date] = {
          payment: pmt,
          interest: int,
          principal: princ,
          balance: bal
        }
      end

      @schedule
    end

    private

    def interim_interest
      return D('0') if @closing_date == @first_payment_due
      return D('0') if @closing_date == (@first_payment_due - 30.days)

      Amortization.interest(@principal, @rate.daily) * interim_days
    end

    def interim_days
      return D('0') if @first_payment_due == @closing_date

      odd_days = (@first_payment_due - 30.days - @closing_date).to_i

      raise NotImplementedError, "Short periods are not yet implemented!" unless odd_days >= 0

      odd_days.positive? ? odd_days : (30 + odd_days) - 30
    end
  end
end

class Numeric
  # @see Amortization#new
  # @api public
  def amortize(rate, opt = {})
    Financier::Amortization.new(self, opt)
  end
end