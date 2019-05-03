require_relative '../spec_helper'

describe Financier::Amortization do
  describe 'payments' do
    context 'no odd days' do
      it 'calculates the monthly payment' do
        expect(Financier::Amortization.payment(10000, (0.1499 / 12), 84)).to eq(-192.91)
      end
    end
  end

  describe 'Numeric#amortize' do
    subject { 1 }

    let(:rate) { Financier::Rate.new(0.01, :apr, duration: 3) }

    it 'responds' do
      expect(subject).to respond_to(:amortize)
    end

    it 'does not cause an error' do
      expect {
        subject.amortize(rate, closing_date: '01-01-19', first_payment_due: '02-01-19')
      }.to_not raise_error(NoMethodError)
    end
  end
end