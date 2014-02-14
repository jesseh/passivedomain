require "spec_helper"
require_dependency Rails.root.join('lib', 'canopy').to_s

describe Canopy do

  class Logger
    def self.log(v)
      (@@log ||= []) << v
    end

    def self.results
      @@log
    end

    def self.reset
      @@log = nil
    end
  end

  before { Logger.reset }

  let(:example_class) do
    Class.new do
      include Canopy
    end
  end

  describe ".canopy_input" do
    context "with no arguments" do
      subject { example_class.canopy_input }
      it { should be_a Canopy::Interface }
    end

    context "with arguments" do
      let(:example_class) do
        Class.new do
          include Canopy

          canopy_input :dangerous_method => ->(input){ raise "Not a string" unless input.is_a? String }

          def dangerous_method(string)
            "Danger " + string
          end

          def boring_method(string)
            "Boring #{string}"
          end
        end
      end

      subject { example_class.new }

      it "should setup validator" do
        expect{ subject.dangerous_method(nil) }.to raise_error("Not a string")
      end

      it "should call original method if valid" do
        expect( subject.dangerous_method("string") ).to eq("Danger string")
      end

      it "should not interfere with other methods" do
        expect( subject.boring_method(nil) ).to eq("Boring ")
      end
    end

    context "when called multiple times" do
      let(:instance){ example_class.new }
      let(:example_class) do
        Class.new do
          include Canopy

          canopy_input :tricky => ->(){ Logger.log 1 }
          canopy_input :tricky => ->(){ Logger.log 2 }

          def tricky; end
        end
      end

      subject! { instance.tricky }

      it "shall in correct order" do
        expect( Logger.results ).to eq([1,2])
      end
    end

    context "when called after a method definition" do
      let(:example_class) do
        Class.new do
          def after; end

          include Canopy
          canopy_input :after => ->(){ raise "still works" }
        end
      end

      subject { example_class.new }

      it "should still call validator" do
        expect{ subject.after }.to raise_error("still works")
      end
    end

    context "when called multiple times before and after" do
      let(:instance){ example_class.new }
      let(:example_class) do
        Class.new do
          include Canopy

          canopy_input :tricky => ->(){ Logger.log 1 }
          def tricky; end
          canopy_input :tricky => ->(){ Logger.log 2 }
        end
      end

      subject! { instance.tricky }

      it "shall in correct order" do
        expect( Logger.results ).to eq([1,2])
      end
    end
  end

  describe ".canopy_output" do
    context "with no arguments" do
      subject { example_class.canopy_output }
      it { should be_a Canopy::Interface }
    end

    context "with arguments" do
      let(:example_class) do
        Class.new do
          include Canopy

          canopy_output :faulty_method => ->(output){ raise "Nil!" if output.nil? }

          def faulty_method(bool)
            bool ? "good" : nil
          end

          def groovy
            "groovy"
          end
        end
      end

      subject { example_class.new }

      it "should setup validator" do
        expect{ subject.faulty_method(false) }.to raise_error("Nil!")
      end

      it "should output result if valid" do
        expect( subject.faulty_method(true) ).to eq("good")
      end

      it "should not interfere with other methods" do
        expect( subject.groovy ).to eq("groovy")
      end
    end

    context "when called multiple times" do
      let(:instance){ example_class.new }
      let(:example_class) do
        Class.new do
          include Canopy

          canopy_output :tricky => ->(v){ Logger.log 1 }
          canopy_output :tricky => ->(v){ Logger.log 2 }

          def tricky; end
        end
      end

      subject! { instance.tricky }

      it "shall in correct order" do
        expect( Logger.results ).to eq([1,2])
      end
    end

    context "when called multiple times before and after" do
      let(:instance){ example_class.new }
      let(:example_class) do
        Class.new do
          include Canopy

          canopy_output :tricky => ->(v){ Logger.log 1 }
          def tricky; end
          canopy_output :tricky => ->(v){ Logger.log 2 }
        end
      end

      subject! { instance.tricky }

      it "shall in correct order" do
        expect( Logger.results ).to eq([1,2])
      end
    end

    context "when called alongside canopy_input" do
      let(:instance){ example_class.new }
      let(:example_class) do
        Class.new do
          include Canopy

          canopy_input  :tricky => ->(){ Logger.log 1 }
          canopy_output :tricky => ->(v){ Logger.log 3 }
          def tricky; end
          canopy_output :tricky => ->(v){ Logger.log 4 }
          canopy_input  :tricky => ->(){ Logger.log 2 }
        end
      end

      subject! { instance.tricky }

      it "shall in correct order" do
        expect( Logger.results ).to eq([1,2,3,4])
      end
    end
  end

end
