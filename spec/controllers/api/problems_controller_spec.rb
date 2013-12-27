require "spec_helper"

describe Api::ProblemsController do

  it { should route(:get, '/api/problems').to(controller: 'api/problems', action: 'index') }
  it { should route(:get, '/api/problems/1').to(controller: 'api/problems', action: 'show', id: '1') }

  let(:store){ double "store" }
  let!(:form_class){ stub_const('Problem::Form', double('Problem::Form')) }
  let!(:store_class){ stub_const('Problem::Store', double('Problem::Store', build: store)) }

  it_behaves_like( "API GET #index" )
  it_behaves_like( "API GET #show" )
  it_behaves_like( "API POST #create" ){ let(:full_params){ {:problem => params} } }

end
