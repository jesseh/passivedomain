require_dependency Rails.root.join('lib', 'number_with_units').to_s

shared_examples "number with units" do
    
  let(:fake) do 
    Class.new do
      include NumberWithUnits

      attr_reader :value

      def initialize(value)
        @value = cast_new_value(value)
        freeze
      end

      def base_unit; "fake"; end
    end.from_base_unit(45)
  end

  it_behaves_like 'value object'

  its(:base_unit) { should be_a_kind_of(String)           }
  its(:to_s)      { should include(subject.base_unit) }
  its(:inspect)   { should include(described_class.to_s) }
  its(:inspect)   { should include("value") }
  its(:inspect)   { should include("base_unit") }
  its(:frozen?)   { should be_true }

  it { expect( subject == fake ).to be_false }
  
  describe "math operations" do
    context "with numeric" do
      it( "*" ){ expect(subject * 3).to be_instance_of(described_class) }
      it( "/" ){ expect(subject / 3).to be_instance_of(described_class) }
      it( "+" ){ expect { subject + 3 }.to raise_exception(TypeError) }
      it( "-" ){ expect { subject - 3 }.to raise_exception(TypeError) }
    end

    context "with same type" do
      let(:similar) { described_class.from_base_unit(5) }

      it( "*" ){ expect { subject * similar }.to raise_exception(TypeError) }
      it( "/" ){ expect( subject / similar ).to be_a_kind_of(Numeric) }
      it( "+" ){ expect( subject + similar ).to be_instance_of(described_class) }
      it( "-" ){ expect( subject - similar ).to be_instance_of(described_class) }
    end

    context "with incompatibale type" do
      it( "*" ){ expect { subject * fake }.to raise_exception(TypeError) }
      it( "/" ){ expect { subject / fake }.to raise_exception(TypeError) }
      it( "+" ){ expect { subject + fake }.to raise_exception(TypeError) }
      it( "-" ){ expect { subject - fake }.to raise_exception(TypeError) }
    end

    context "with equal value" do
      let(:same_value) { subject.dup }

      it( "*" ){ expect { subject * same_value }.to raise_exception(TypeError) }
      it( "/" ){ expect( subject / same_value ).to eq(1) }
      it( "+" ){ expect( subject + same_value ).to eq(subject * 2) }
      it( "-" ){ expect( subject - same_value ).to eq(subject * 0) }
    end
  end

end
