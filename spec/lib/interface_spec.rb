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

  subject { described_class.new(FakeClass9645) }

  it "is created with a value object class" do
   expect(subject).to be 
  end
    
  it "describes the in-bound (what the object calls) interface of a class" do
    expect(subject.calls).to eq({:an_attr => [],
                                 :another_attr => [PassiveDomain::Only.number]
                               })
  end

  it "describes the out-bound (to what the object responds) interface of a class" do
    expect(subject.responds_to).to match_array([:the_method, :an_attr])
  end
end
