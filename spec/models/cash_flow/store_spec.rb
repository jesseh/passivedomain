require "spec_helper"

describe CashFlow::Store do
  let(:model){ double("Detail").as_null_object }
  let(:instance){ described_class.new(record, model) }

  it_behaves_like "a store" do
    let(:active_record_class_name){ 'CashFlow::Record' }
  end

end
