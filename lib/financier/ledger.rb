module Financier
  class Ledger
    attr_reader :transactions

    def initialize(*transactions)
      send(:transactions=, *transactions)
    end

    def transactions=(*transactions)
      @transactions = []
      transactions.flatten.each do |transaction|
        send(:<<, transaction)
      end
      @transactions
    end

    def <<(transaction)
      transaction = Transaction.new(transaction.to_s) unless
        transaction.is_a?(Transaction)

      @transactions << transaction
      @transactions.sort {|a, b| a.date <=> b.date }

      transaction
    end
    alias_method :push, :<<

    def credits
      transactions.select(&:credit?)
    end

    def debits
      transactions.select(&:debit?)
    end

    def balance(before: nil, after: nil, between: nil, within: nil)
      transactions_to_sum = transactions.dup

      between = (within.first - 1.day)..(within.last + 1.day) if within
      after, before = [between.first, between.last] if between
      transactions_to_sum.select! { |t| t.before?(before) } if before
      transactions_to_sum.select! { |t| t.after?(after) } if after

      transactions_to_sum
        .collect(&:amount)
        .sum
    end
  end
end