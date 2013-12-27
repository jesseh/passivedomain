require "spec_helper"

describe Rig::Model do

  describe ".money_builder" do
    let(:money_class){ double("Money class") }

    before { stub_const("Money", money_class) }

    subject { described_class.money_builder }

    it { should eql(money_class) }
  end

  describe "#name" do
    before{ subject.name = 'fred' }
    its(:name) { should eql('fred') }
  end

  describe "#hash_rate" do
    before{ subject.hash_rate = 5.0e09 }
    its(:hash_rate) { should eql(5.0e09) }
  end

  describe "#power" do
    before{ subject.power = 30 }
    its(:power) { should eql(30) }
  end

  describe "#price_fractional" do
    before{ subject.price_fractional = 50_00 }
    its(:price_fractional) { should eql(50_00) }
  end

  describe "#price_currency" do
    before{ subject.price_currency = 'USD' }
    its(:price_currency){ should eql('USD') }
  end

  describe "#price" do
    let(:money){ double("Money") }
    let(:money_class){ double("Money class", :new => money) }

    let(:instance){ described_class.new }

    before do
      allow( described_class ).to receive(:money_builder){ money_class }
      allow( instance ).to receive(:price_fractional){ 30_00 }
      allow( instance ).to receive(:price_currency){ "GBP" }
    end

    subject! { instance.price }

    it{ expect( money_class ).to have_received(:new).with(30_00, "GBP") }
    it{ should eql(money) }
  end

end
