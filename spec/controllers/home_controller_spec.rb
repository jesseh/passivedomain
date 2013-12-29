require "spec_helper"

describe HomeController do

  it { should route(:get, '/').to(controller: 'home', action: 'index') }

  describe "on GET to #index" do
    before { get :index }
    it { should respond_with(:success) }
  end

end
