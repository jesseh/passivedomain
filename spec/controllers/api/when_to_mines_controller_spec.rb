require "spec_helper"

describe Api::WhenToMinesController do

  it { should route(:get, '/api/when_to_mines').to(controller: 'api/when_to_mines', action: 'index') }
  it { should route(:get, '/api/when_to_mines/1').to(controller: 'api/when_to_mines', action: 'show', id: '1') }

  let(:store){ double "store" }
  let!(:form_class){ stub_const('WhenToMine::Form', double('WhenToMine::Form')) }
  let!(:store_class){ stub_const('WhenToMine::Store', double('WhenToMine::Store', build: store)) }

  it_behaves_like( "API GET #index" )
  it_behaves_like( "API GET #show" )
  it_behaves_like( "API POST #create" ){ let(:full_params){ {:when_to_mine => params} } }

end
