require "spec_helper"

describe Api::RigsController do

  it { should route(:get, '/api/rigs').to(controller: 'api/rigs', action: 'index') }
  it { should route(:get, '/api/rigs/1').to(controller: 'api/rigs', action: 'show', id: '1') }

  let(:store){ double "store" }
  let!(:form_class){ stub_const('Rig::Form', double('Rig::Form')) }
  let!(:store_class){ stub_const('Rig::Store', double('Rig::Store', build: store)) }

  it_behaves_like( "API GET #index" )
  it_behaves_like( "API GET #show" )
  it_behaves_like( "API POST #create" ){ let(:full_params){ {:rig => params} } }

end
