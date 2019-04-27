module Financier
  class Transaction
    attr_reader :amount
    attr_reader :date

    def initialize(amount, date = Date.today)
      send(:amount=, amount)
      send(:date=, date)
    end

    def amount=(value)
      @amount = Flt::DecNum.new(value.to_s)
    end

    def credit?
      amount.positive?
    end

    def date=(value)
      @date = value.to_date
    end

    def on?(other_date)
      date === other_date.to_date
    end

    def before?(other_date)
      date < other_date.to_date
    end

    def after?(other_date)
      date > other_date.to_date
    end

    def debit?
      amount.negative?
    end

    def zero?
      amount.zero?
    end

    def to_s
      amount.to_s
    end
  end
end