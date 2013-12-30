require "spec_helper"

describe WhenToMine::CalculatorsController do

  it { should route(:get, '/when_to_mine/calculator').to(controller: 'when_to_mine/calculators', action: 'show') }
  it { should route(:post, '/when_to_mine/calculator').to(controller: 'when_to_mine/calculators', action: 'create') }

  describe "on GET to #show" do
    before { get :show }
    it { should respond_with(:success) }
  end

  describe "on POST to #create" do
    before { post :create }
    it { should redirect_to(action: :show) }
  end

end
