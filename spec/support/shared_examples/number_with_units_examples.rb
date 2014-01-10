shared_examples "number with units" do
    
  subject { described_class.from_base_unit(987) }

  let(:fake) do 
    Class.new do
      include NumbersWithUnits::NumberWithUnits

      def base_unit; "fake"; end
    end.from_base_unit(45)
  end

  it_behaves_like 'value object'

  its(:base_unit) { should be_a_kind_of(String)           }
  its(:to_s)      { should include('987') }
  its(:to_s)      { should include(subject.base_unit) }
  its(:inspect)   { should include(described_class.to_s) }
  its(:inspect)   { should include("value") }
  its(:inspect)   { should include("base_unit") }

  it { expect( described_class.from_base_unit(161) == fake ).to be_false }
  
  it "should require a factory method to create" do
    expect { described_class.new(123) }.to raise_error(NoMethodError)
  end

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
