require "spec_helper"

describe Problem::Store do

  it_behaves_like "a store" do
    let(:active_record_class_name){ 'Problem::Model' }
  end

end
