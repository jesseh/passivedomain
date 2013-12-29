require "spec_helper"

describe WhenToMine::CalculatorsController do

  it { should route(:get, '/when_to_mine/calculator').to(controller: 'when_to_mine/calculators', action: 'show') }

  describe "on GET to #show" do
    before { get :show }
    it { should respond_with(:success) }
  end

end
