require_relative '../spec_helper'

describe Financier::Transaction do
  subject { Financier::Transaction }

  let(:transaction) { subject.new(1) }

  describe 'amount' do
    it 'is gettable' do
      expect(transaction).to respond_to(:amount)
    end

    describe 'setting' do
      let!(:old_amt) { transaction.instance_variable_get('@amount') }
      let(:new_amt) { transaction.instance_variable_get('@amount') }

      before { transaction.amount = 2 }

      it 'sets the amount' do
        expect(new_amt).to_not eq(old_amt)
      end

      it 'converts the amount to DecNum' do
        expect(new_amt).to be_a(Flt::DecNum)
      end
    end
  end

  describe 'date' do
    it 'is gettable' do
      expect(transaction).to respond_to(:date)
    end

    describe 'setting' do
      let!(:old_date) { transaction.instance_variable_get('@date') }
      let(:new_date) { transaction.instance_variable_get('@date') }

      before { transaction.date = 1.day.ago }

      it 'sets the date' do
        expect(new_date).to_not eq(old_date)
      end

      it 'converts the date to a Date' do
        expect(new_date).to be_a(Date)
      end
    end

    describe '#on?' do
      it 'returns appropriate responses' do
        expect(transaction.on?(1.day.ago)).to be false
        expect(transaction.on?(Date.today)).to be true
        expect(transaction.on?(1.day.from_now)).to be false
      end
    end

    describe '#before?' do
      it 'returns appropriate responses' do
        expect(transaction.before?(1.day.ago)).to be false
        expect(transaction.before?(Date.today)).to be false
        expect(transaction.before?(1.day.from_now)).to be true
      end
    end

    describe '#after?' do
      it 'returns appropriate responses' do
        expect(transaction.after?(1.day.ago)).to be true
        expect(transaction.after?(Date.today)).to be false
        expect(transaction.after?(1.day.from_now)).to be false
      end
    end
  end

  describe 'credit/debit/zero' do
    let(:credit) { subject.new(123) }
    let(:debit) { subject.new(-123) }
    let(:zero) { subject.new(0) }
    let(:non_zero) { credit }

    describe '#credit?' do
      it 'is true for positive amounts' do
        expect(credit.credit?).to be true
      end

      it 'is false for negative amounts' do
        expect(debit.credit?).to be false
      end

      it 'is false for zero amounts' do
        expect(zero.credit?).to be false
      end
    end

    describe '#debit?' do
      it 'is true for negative amounts' do
        expect(debit.debit?).to be true
      end

      it 'is false for positive amounts' do
        expect(credit.debit?).to be false
      end

      it 'is false for zero amounts' do
        expect(zero.debit?).to be false
      end
    end

    describe '#zero?' do
      it 'is true for zero amounts' do
        expect(zero.zero?).to be true
      end

      it 'is false for non-zero amounts' do
        expect(non_zero.zero?).to be false
      end
    end
  end
end