require 'spec_helper'
require_dependency Rails.root.join('lib', 'specification').to_s


describe 'Specification' do

  describe '.create dsl' do
    subject do

      Specification.create do
        initialize [string, number]
        
        copy OtherClass1::INTERFACE
        copy OtherClass2::INTERFACE.include [:initialize, :a, :b]
        copy OtherClass3::INTERFACE.exclude [:x, :y, :z]

        queries do
          cool?    [string, string], number
          another  [], number
        end

        commands do
          do_this  [interface(yada)]
        end
      end

    end

    it "returns an Interface object" do
      expect( subject ).to be_instance_of(Specification::Interface)
    end
    
    xit "has the right signatures"
  end
end

