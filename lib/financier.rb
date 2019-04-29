require 'active_support/all'
require 'chronic'
require 'flt'
require 'flt/d'

require 'financier/amortization'
require 'financier/date'
require 'financier/ledger'
require 'financier/rate'
require 'financier/transaction'
require 'financier/version'

module Financier
  class Error < StandardError; end
end
