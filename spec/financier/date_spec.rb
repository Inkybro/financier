require_relative '../spec_helper'

describe Financier::Date do
  let(:date_string) { Time.now.strftime('%Y-%m-%d') }
  let(:date) { ::Date.today }
  let(:time) { Time.now }

  it 'parses dates from strings' do
    expect(Financier::Date[date_string]).to be_a(::Date)
    expect(Financier::Date[date_string]).to eq(::Date.today)
  end

  it 'parses dates from dates' do
    expect(Financier::Date[date]).to be_a(::Date)
  end

  it 'parses dates from times' do
    expect(Financier::Date[time]).to be_a(::Date)
  end

  it 'returns nil for nil values by default' do
    expect(Financier::Date[nil]).to be(nil)
  end

  it 'returns specified default for nil values' do
    expect(Financier::Date[time]).to be_a(::Date)
  end
end