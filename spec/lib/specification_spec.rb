require 'spec_helper'
require_dependency Rails.root.join('lib', 'specification').to_s


describe 'Specification' do

  describe '.create dsl' do
    subject do

      Specification.create do
        initialize_with [string, number]
        
        copy(OtherClass1::INTERFACE)
        copy(OtherClass1::INTERFACE, [:x, :y, :z])

        querying(:cool?).with(a.string, a.string => :optional).returns(a.number)
        querying(:a_query).returns(a.number)

        commanding(:do_this).with(an.object_conforming_to(yada)).returns(a.anything)
        commanding(:a_command).returns(a.nil)

      end

    end

    it "returns an Interface object" do
      expect( subject ).to be_instance_of(Specification::Interface)
    end
    
    it "has the query signatures" do
      expect(subject.valid_method? :a_query).to be_true
    end

    xit "seperates queries and commands"
  end
end

