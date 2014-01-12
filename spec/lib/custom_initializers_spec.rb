require "spec_helper"
require_dependency Rails.root.join('lib', 'custom_initializers').to_s


describe CustomInitializers do
  describe "value_object_initializer" do
    let(:data) { double("Data", an_attr: 123) }
    let(:fake_class) do
      Class.new do
        extend CustomInitializers
        value_object_initializer :an_attr
      end
    end
    let(:fake_subclass) { Class.new(fake_class) }

    subject { fake_class.new(data) }

    it "freezes the instance" do
      expect(subject.frozen?).to be_true
    end

    it "makes private attr accessors" do
      expect {subject.an_attr}.to raise_error(NoMethodError)
      expect(subject.send(:an_attr)).to eq(123)
    end

    it_behaves_like 'value object'

    it "takes class into account for equality" do
      expect(subject).to_not eq(fake_subclass.new(data)) 
    end

    context "a list of attributes" do
      let(:data) { double("Data", attr_1: 123, attr_2: 456) }
      let(:fake_class) do
        Class.new do
          extend CustomInitializers
          value_object_initializer :attr_1, :attr_2
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
          extend CustomInitializers
          value_object_initializer :attr_1 => :one, :attr_2 => :two
        end
      end
      its(:one) { should == 123 }
      its(:two) { should == 456 }
    end

    context "a list of attributes with only some target names" do
      let(:data) { double("Data", attr_1: 123, attr_2: 456) }
      let(:fake_class) do
        Class.new do
          extend CustomInitializers
          value_object_initializer :attr_1, :attr_2 => :two
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
          end

          def sentinal
            'sentinal'
          end
        end

        Class.new do
          extend CustomInitializers
          value_object_initializer ComposedClass
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
          end

          def sentinal
            'sentinal'
          end
        end

        Class.new do
          extend CustomInitializers
          value_object_initializer ComposedClass => :attr_from_class
        end
      end
      its("attr_from_class.sentinal") { should == 'sentinal' }
      its("attr_from_class.attr_1") { should == 123 }
    end
  end
end
