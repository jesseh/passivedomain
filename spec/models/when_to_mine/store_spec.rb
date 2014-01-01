require "spec_helper"

describe WhenToMine::Store do

  it_behaves_like "a store" do
    let(:active_record_class_name){ 'WhenToMine::Model' }
  end

end
