module Financier
  class Rate
    class << self
      def to_effective(rate, periods)
        rate, periods = Flt::DecNum.new(rate.to_s), Flt::DecNum.new(periods.to_s)

        return rate.exp - 1 if periods.infinite?

        (1 + rate / periods) ** periods - 1
      end

      def to_nominal(rate, periods)
        rate, periods = Flt::DecNum.new(rate.to_s), Flt::DecNum.new(periods.to_s)

        return (rate + 1).log if periods.infinite?

        periods * ((1 + rate) ** (1 / periods) - 1)
      end
    end

    include Comparable

    # Accepted rate types
    TYPES = { :apr       => "effective",
              :apy       => "effective",
              :effective => "effective",
              :nominal   => "nominal"
            }

    # @return [Integer] the duration for which the rate is valid, in months
    # @api public
    attr_accessor :duration
    # @return [DecNum] the effective interest rate
    # @api public
    attr_reader :effective
    # @return [DecNum] the nominal interest rate
    # @api public
    attr_reader :nominal

    # compare two Rates, using the effective rate
    # @return [Numeric] one of -1, 0, +1
    # @param [Rate] rate the comparison Rate
    # @example Which is better, a nominal rate of 15% compounded monthly, or 15.5% compounded semiannually?
    #   r1 = Rate.new(0.15, :nominal) #=> Rate.new(0.160755, :apr)
    #   r2 = Rate.new(0.155, :nominal, :compounds => :semiannually) #=> Rate.new(0.161006, :apr)
    #   r1 <=> r2 #=> -1
    # @api public
    def <=>(rate)
      @effective <=> rate.effective
    end

    # (see #effective)
    # @api public
    def apr
      self.effective
    end

    # (see #effective)
    # @api public
    def apy
      self.effective
    end

    # a convenience method which sets the value of @periods
    # @return none
    # @param [Symbol, Numeric] input the compounding frequency
    # @raise [ArgumentError] if input is not an accepted keyword or Numeric
    # @api private
    def compounds=(input)
      @periods = case input
                 when :annually     then Flt::DecNum.new(1)
                 when :continuously then Flt::DecNum.infinity
                 when :daily        then Flt::DecNum.new(365)
                 when :monthly      then Flt::DecNum.new(12)
                 when :quarterly    then Flt::DecNum.new(4)
                 when :semiannually then Flt::DecNum.new(2)
                 when Numeric       then Flt::DecNum.new(input.to_s)
                 else raise ArgumentError
                 end
    end

    # set the effective interest rate
    # @return none
    # @param [DecNum] rate the effective interest rate
    # @api private
    def effective=(rate)
      @effective = Flt::DecNum.new(rate.to_s)
      @nominal = Rate.to_nominal(rate, @periods)
    end

    # create a new Rate instance
    # @return [Rate]
    # @param [Numeric] rate the decimal value of the interest rate
    # @param [Symbol] type a valid {TYPES rate type}
    # @param [optional, Hash] opts set optional attributes
    # @option opts [String] :duration a time interval for which the rate is valid
    # @option opts [String] :compounds (:monthly) the number of compounding periods per year
    # @example create a 3.5% APR rate
    #   Rate.new(0.035, :apr) #=> Rate(0.035, :apr)
    # @see http://en.wikipedia.org/wiki/Effective_interest_rate
    # @see http://en.wikipedia.org/wiki/Nominal_interest_rate
    # @api public
    def initialize(rate, type, opts={})
      # Default monthly compounding.
      opts = { :compounds => :monthly }.merge opts

      # Set optional attributes..
      opts.each do |key, value|
        send("#{key}=", value)
      end

      # Set the rate in the proper way, based on the value of type.
      begin
        send("#{TYPES.fetch(type)}=", Flt::DecNum.new(rate.to_s))
      rescue KeyError
        raise ArgumentError, "type must be one of #{TYPES.keys.join(', ')}", caller
      end
    end

    def inspect
      "Rate.new(#{self.apr.round(6)}, :apr)"
    end

    # @return [DecNum] the monthly effective interest rate
    # @example
    #   rate = Rate.new(0.15, :nominal)
    #   rate.apr.round(6) #=> DecNum('0.160755')
    #   rate.monthly.round(6) #=> DecNum('0.013396')
    # @api public
    def monthly
      (self.effective / 12).round(15)
    end

    def daily
      # TODO - Add spec
      (self.effective / 360).round(15)
    end

    # set the nominal interest rate
    # @return none
    # @param [DecNum] rate the nominal interest rate
    # @api private
    def nominal=(rate)
      @nominal = Flt::DecNum.new(rate.to_s)
      @effective = Rate.to_effective(rate, @periods)
    end
  end
end