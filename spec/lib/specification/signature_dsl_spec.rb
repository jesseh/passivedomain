require 'spec_helper'
require_dependency Rails.root.join('lib', 'specification', 'signature_dsl').to_s
require_dependency Rails.root.join('lib', 'specification', 'signatures', 'query').to_s
require_dependency Rails.root.join('lib', 'specification').to_s

describe Specification::SignatureDSL do

  describe "specifying a simple method" do
    subject { described_class.new.type(:query).named(:any_method).build }

    it 'creates a query signature with the method name' do
      expect(subject).to be_instance_of Specification::Signatures::Query
      expect(subject.method_symbol).to eq(:any_method)
    end
  end

  describe "specifying a complex method" do
    subject { described_class.new.type(:query).
                                  named(:any_method).
                                  with(Specification::Only.string,
                                       Specification::Only.string=>:optional).
                                  returns(Specification::Only.number).
                                  build
            }

    it "sets the arguments" do
      expect(subject.valid_arguments?(['yada', 'yada'])).to be_true
    end

    it "sets the arguments" do
      expect(subject.valid_response?(111)).to be_true
    end

    it "sets the optional arguments" do
      expect(subject.valid_arguments?(['yada'])).to be_true
    end

    it "raises an error the hash values are not all :optional" do
      expect { described_class.new.type(:query).
                                   named(:any_method).
                                  with(Specification::Only.string,
                                       Specification::Only.string=>:anything_else)
            }.to raise_error ArgumentError
    end
  end
end
