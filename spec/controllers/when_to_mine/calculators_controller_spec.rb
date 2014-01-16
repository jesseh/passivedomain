require "spec_helper"

describe WhenToMine::CalculatorsController do


  it { should route(:get, '/when_to_mine/calculator').
          to(controller: 'when_to_mine/calculators', action: 'show') }
  it { should route(:post, '/when_to_mine/calculator').
          to(controller: 'when_to_mine/calculators', action: 'create') }

  describe "GET to #show" do
    let(:data_source) { double("data source", :canned => :mapping_sentinal) }

    before do
      CashFlow::Report.stub(:new => :report_sentinal)
      CashFlow::DataSource.stub(:new => data_source)
      get :show
    end

    it { expect(CashFlow::DataSource).to have_received(:new) }
    it { expect(CashFlow::Report).to have_received(:new).with(:mapping_sentinal) }
    it { expect(data_source).to have_received(:canned) }
    it { expect(assigns(:report)).to eq(:report_sentinal) }

    it { should respond_with(:success) }
  end

end
