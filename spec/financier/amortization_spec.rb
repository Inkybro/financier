require_relative '../spec_helper'

describe Financier::Amortization do
  describe 'payments' do
    context 'no odd days' do
      it 'calculates the monthly payment' do
        expect(Financier::Amortization.payment(10000, (0.1499 / 12), 84)).to eq(-192.91)
      end
    end
  end
end