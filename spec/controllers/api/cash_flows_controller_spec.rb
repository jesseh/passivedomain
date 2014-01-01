require "spec_helper"

describe Api::CashFlowsController do

  it { should route(:get, '/api/cash_flows').to(controller: 'api/cash_flows', action: 'index') }
  it { should route(:get, '/api/cash_flows/1').to(controller: 'api/cash_flows', action: 'show', id: '1') }

  let(:store){ double "store" }
  let!(:form_class){ stub_const('CashFlow::Form', double('CashFlow::Form')) }
  let!(:store_class){ stub_const('CashFlow::Store', double('CashFlow::Store', build: store)) }

  it_behaves_like( "API GET #index" )
  it_behaves_like( "API GET #show" )
  it_behaves_like( "API POST #create" ){ let(:full_params){ {:cash_flow => params} } }

end
