module Financier
  module Date
    def self.[](value, default = nil)
      return default unless value

      return value if value.is_a?(::Date)
      
      return value.to_date if value.is_a?(Time)

      Chronic.parse(value.to_s).to_date
    end
  end
end