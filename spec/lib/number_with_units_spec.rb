require 'spec_helper'

describe NumberWithUnits do
  it "sets #number_type to be its class" do
    Yada = Class.new { include NumberWithUnits }
    expect( Yada.new.number_type ).to eq(Yada)
  end


end
