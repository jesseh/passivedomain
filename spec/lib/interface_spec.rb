require "spec_helper"
require_dependency Rails.root.join('lib', 'passive_domain').to_s
require_dependency Rails.root.join('lib', 'passive_domain', 'only').to_s
require_dependency Rails.root.join('lib', 'passive_domain', 'interface').to_s


describe PassiveDomain::Interface do
  class FakeClass9645
    extend PassiveDomain
    value_object_initializer do
      value(:an_attr) 
      value(:another_attr).must_be(only.number)
    end
    def the_method
    end
    attr_reader :an_attr
  end


  describe "initialization" do
    subject { described_class.new(FakeClass9645) }
    
    it "describes the in-bound (what the object sends) interface of a class" do
      expect(subject.sends).to eq({:an_attr => nil,
                                   :another_attr => PassiveDomain::Only.number
                                 })
    end

    it "describes the out-bound (to what the object responds) interface of a class" do
      expect(subject.responds_to).to match_array([:the_method, :an_attr])
    end
    
    it "checks that the only requirements are consistent for a given input." do
      example_class = Class.new do
        extend PassiveDomain
        value_object_initializer do
          value(:an_attr).must_be(only.string)   
          value(:an_attr).must_be(only.number)
        end
      end
      expect { described_class.new(example_class) }.to raise_error
    end

    it "is ok with two of the same only requirements for a given input." do
      example_class = Class.new do
        extend PassiveDomain
        value_object_initializer do
          value(:an_attr).must_be(only.string)   
          value(:an_attr).must_be(only.string)
        end
      end
      expect { described_class.new(example_class) }.to_not raise_error
    end
  end

  describe "#responder" do
    subject { described_class.new(FakeClass9645).responder }

    it "responds with a default values for all sends to which it responds" do
      expect {subject.an_attr}.to_not raise_error
      expect(subject.another_attr).to be_a_kind_of Numeric
    end

    it "responds with a random value for sends, where possible" do
      sequence = Array.new(10) { subject.another_attr}
      is_random = sequence.uniq.count > 0
      expect(is_random).to be_true
    end

    it "responds with supplied params when present" do
      interface = described_class.new(FakeClass9645)
      instance = interface.responder(another_attr: 5, an_attr: "yada") 

      expect(instance.an_attr).to eq("yada")
      expect(instance.another_attr).to eq(5)
    end
  end
end
