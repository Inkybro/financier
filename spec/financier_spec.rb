require_relative 'spec_helper'

describe Financier do
  it 'has a version' do
    expect(subject.constants).to include(:VERSION)
  end
end