require "spec_helper"

describe WhenToMine::CalculatorsController do


  it { should route(:get, '/when_to_mine/calculator').
          to(controller: 'when_to_mine/calculators', action: 'show') }
  it { should route(:post, '/when_to_mine/calculator').
          to(controller: 'when_to_mine/calculators', action: 'create') }

  describe "GET to #show" do
    before do
      CashFlow::Report.stub(:new => :report_sentinal)
      CashFlow::Mapper.stub(:new => :mapper_sentinal)
      get :show
    end
    it { should respond_with(:success) }
    it { expect(CashFlow::Mapper).to have_received(:new) }
    it { expect(CashFlow::Report).to have_received(:new).with(:mapper_sentinal) }
    it { expect(assigns(:report)).to eq(:report_sentinal) }
  end

end
