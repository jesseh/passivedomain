require 'spec_helper'

describe CashFlow::Widget do
  subject { described_class.new 'test string'.freeze }

  describe "#html" do
    it "returns the value" do
      expect(subject.html).to eq('test string')
    end
  end

  describe "#response" do
    it "returns the value" do
      expect(subject.response).to eq('test string')
    end
  end
end
