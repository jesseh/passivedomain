require "spec_helper"
require_dependency Rails.root.join('lib', 'passive_domain').to_s


describe PassiveDomain do
  describe "value_object_initializer" do
    let(:an_attr) { 123 } 
    let(:data) { double("Data", an_attr: an_attr) }
    let(:fake_class) do
      class FakeClass
        extend PassiveDomain
        value_object_initializer { value(:an_attr) }
      end
      FakeClass
    end
    let(:fake_subclass) { 
      class SubFakeClass < FakeClass
      end
      SubFakeClass
    }

    subject { fake_class.new(data) }

    it_behaves_like 'value object'

    describe "optionally invokes methods to prepare values" do
      let(:fake_class) do
        Class.new do
          extend PassiveDomain
          value_object_initializer { value(:an_attr) }
          def an_attr; @an_attr * 2; end
        end
      end
      let(:data) { double("Data", an_attr: 2) }
      its(:an_attr) { should == 4 }
    end

    describe "value syntax" do
      let(:fake_class) do
        Class.new do
          extend PassiveDomain
          value_object_initializer { value(:an_attr) }
        end
      end
      let(:data) { double("Data", an_attr: 2) }
      its(:an_attr) { should == 2 }
    end

    describe "value with only.number" do
      let(:fake_class) do
        Class.new do
          extend PassiveDomain
          value_object_initializer { value(:an_attr).must_be(only.number) }
        end
      end
      let(:data) { double("Data", an_attr: 2) }
      its(:an_attr) { should == 2 }
    end

    describe "value with only.string" do
      let(:fake_class) do
        Class.new do
          extend PassiveDomain
          value_object_initializer { value(:an_attr).must_be(only.string) }
        end
      end
      let(:data) { double("Data", an_attr: 2) }

      subject { }

      it { expect { fake_class.new(data) }.to raise_error }
    end

    describe "enforces all attr values are frozen" do
      context "unfrozen data" do
        let(:an_attr) { 'a' }
        it { expect { fake_class.new(data) }.to raise_error }
      end
      context "frozen data" do
        let(:an_attr) { 'a'.freeze }
        it { expect { fake_class.new(data) }.not_to raise_error }
      end
      context "data is nil" do
        let(:an_attr) { nil }
        it { expect { fake_class.new(data) }.not_to raise_error }
      end
      context "data is true" do
        let(:an_attr) { true }
        it { expect { fake_class.new(data) }.not_to raise_error }
      end
      context "data is false" do
        let(:an_attr) { false }
        it { expect { fake_class.new(data) }.not_to raise_error }
      end

    end

    it "makes private attr accessors" do
      expect {subject.an_attr}.to raise_error(NoMethodError)
      expect(subject.send(:an_attr)).to eq(123)
    end

    it "takes class into account for equality" do
      expect(subject).to_not eq(fake_subclass.new(data)) 
    end

    context "a list of attributes" do
      let(:data) { double("Data", attr_1: 123, attr_2: 456) }
      let(:fake_class) do
        Class.new do
          extend PassiveDomain
          value_object_initializer do
            value(:attr_1)
            value(:attr_2)
          end
        end
      end
      # Note: "its" can query the subject's private methods.
      its(:attr_1) { should == 123 }
      its(:attr_2) { should == 456 }
    end

    context "a list of attributes with target names" do
      let(:data) { double("Data", attr_1: 123, attr_2: 456) }
      let(:fake_class) do
        Class.new do
          extend PassiveDomain
          value_object_initializer do
            value(:attr_1 => :one)
            value(:attr_2 => :two)
          end
        end
      end
      its(:one) { should == 123 }
      its(:two) { should == 456 }
    end

    context "a list of attributes with only some target names" do
      let(:data) { double("Data", attr_1: 123, attr_2: 456) }
      let(:fake_class) do
        Class.new do
          extend PassiveDomain
          value_object_initializer do
            value(:attr_1)
            value(:attr_2 => :two)
          end
        end
      end
      its(:attr_1) { should == 123 }
      its(:two) { should == 456 }
    end

    context "a class as an attribute" do
      let(:data) { double("Data", attr_1: 123, attr_2: 456) }
      let(:fake_class) do
        class ComposedClass

          attr_reader :attr_1

          def initialize(data)
            @attr_1 = data.attr_1
            freeze
          end

          def sentinal
            'sentinal'
          end
        end

        Class.new do
          extend PassiveDomain
          value_object_initializer { value(ComposedClass) }
        end
      end
      its("composed_class.sentinal") { should == 'sentinal' }
      its("composed_class.attr_1") { should == 123 }
    end

    context "a class as an attribute" do
      let(:data) { double("Data", attr_1: 123, attr_2: 456) }
      let(:fake_class) do
        class ComposedClass

          attr_reader :attr_1

          def initialize(data)
            @attr_1 = data.attr_1
            freeze
          end

          def sentinal
            'sentinal'
          end
        end

        Class.new do
          extend PassiveDomain
          value_object_initializer { value(ComposedClass => :attr_from_class) }
        end
      end
      its("attr_from_class.sentinal") { should == 'sentinal' }
      its("attr_from_class.attr_1") { should == 123 }
    end
  end
end
