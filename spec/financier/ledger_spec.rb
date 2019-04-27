require_relative '../spec_helper'

describe Financier::Ledger do
  let(:transaction) { Financier::Transaction }

  subject do
    Financier::Ledger.new(
      transaction.new(500, 1.year.ago),
      transaction.new(-150, 6.months.ago),
      transaction.new(-250, 2.weeks.ago)
    )
  end

  describe 'transactions' do
    describe '#<<' do
      before { subject << transaction.new(2) }

      it 'adds a transaction' do
        expect(subject.transactions.length).to eq(4)        
      end

      it 'is aliased as push' do
        expect(subject).to respond_to(:push)
      end

      it 'coerces non-transactions' do
        subject << 120
        expect(subject.transactions.last).to be_a(transaction)
        expect(subject.transactions.last.amount).to eq(120)
      end
    end

    describe '#transactions' do
      it 'returns the transactions' do
        expect(subject.transactions.length).to eq(3)
      end
    end

    describe '#credits' do
      it 'returns the credit transactions' do
        expect(subject.credits.length).to eq(1)
      end
    end

    describe '#debits' do
      it 'returns the debit transactions' do
        expect(subject.debits.length).to eq(2)
      end
    end
  end

  describe 'coercion' do
  end

  describe 'calculation' do
    describe '#balance' do
      it 'sums all transactions' do
        expect(subject.balance).to eq(100)
      end

      describe 'before' do
        it 'sums transactions before date' do
          expect(subject.balance(before: 4.weeks.ago)).to eq(350)
        end
      end

      describe 'after' do
        it 'sums transactions after date' do
          expect(subject.balance(after: 7.months.ago)).to eq(-400)
        end
      end

      describe 'between' do
        it 'sums transactions between dates' do
          expect(subject.balance(between: 7.months.ago..4.weeks.ago)).to eq(-150)
        end
      end

      describe 'within' do
        it 'sums transactions within dates' do
          expect(subject.balance(within: subject.transactions.first.date..subject.transactions[1].date)).to eq(350)
        end
      end
    end
  end
end