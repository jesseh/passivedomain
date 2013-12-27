require "spec_helper"

describe Rig::Form do

  describe ".new" do
    context "with symbol keys" do
      let(:params){ {
        name:             'name',
        hash_rate:        'hash_rate',
        power:            'power',
        price_fractional: 'price_fractional'
      } }

      subject { described_class.new params }

      its(:name) { should eql(params[:name]) }
      its(:hash_rate) { should eql(params[:hash_rate]) }
      its(:power) { should eql(params[:power]) }
      its(:price_fractional) { should eql(params[:price_fractional]) }
    end

    context "with string keys" do
      let(:params){ {
        'name'             => 'name',
        'hash_rate'        => 'hash_rate',
        'power'            => 'power',
        'price_fractional' => 'price_fractional'
      } }

      subject { described_class.new params }

      its(:name) { should eql(params['name']) }
      its(:hash_rate) { should eql(params['hash_rate']) }
      its(:power) { should eql(params['power']) }
      its(:price_fractional) { should eql(params['price_fractional']) }
    end
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
    its(:price_currency){ should eql('USD') }
  end

  describe "#persisted?" do
    its(:persisted?){ should be_false }
  end

  describe "#attributes" do
    let(:params){ {
      name:             'name',
      hash_rate:        'hash_rate',
      power:            'power',
      price_fractional: 'price_fractional',
      with_some:        'extras'
    } }

    subject { described_class.new params }

    its(:attributes){
      should eql({
        name:             'name',
        hash_rate:        'hash_rate',
        power:            'power',
        price_fractional: 'price_fractional'
      })
    }
  end

  describe "validations" do
    context "name" do
      it { should allow_value('colossus').for(:name) }
      it { should_not allow_value('').for(:name) }
      it { should_not allow_value(nil).for(:name) }
    end

    context "price_fractional" do
      it { should allow_value(50_00).for(:price_fractional) }
      it { should allow_value(0).for(:price_fractional) }
      it { should_not allow_value(-50_00).for(:price_fractional) }
      it { should_not allow_value(50.01).for(:price_fractional) }
      it { should_not allow_value('eggs').for(:price_fractional) }
    end

    context "hash_rate" do
      it { should allow_value(5e9).for(:hash_rate) }
      it { should_not allow_value(0).for(:hash_rate) }
      it { should_not allow_value(-5e9).for(:hash_rate) }
      it { should_not allow_value('eggs').for(:hash_rate) }
    end

    context "power" do
      it { should allow_value(30).for(:hash_rate) }
      it { should_not allow_value(0).for(:hash_rate) }
      it { should_not allow_value(-30).for(:hash_rate) }
      it { should_not allow_value('eggs').for(:hash_rate) }
    end
  end

end
