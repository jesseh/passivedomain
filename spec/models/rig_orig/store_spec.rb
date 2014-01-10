require "spec_helper"

describe RigOrig::Store do

  it_behaves_like "a store" do
    let(:active_record_class_name){ 'Rig::Model' }
  end

end
