require "spec_helper"

describe CashFlow::Store do

  it_behaves_like "a store" do
    let(:active_record_class_name){ 'CashFlow::Record' }
  end

  # TODO: add tests for the precision of money fractional fields

end
