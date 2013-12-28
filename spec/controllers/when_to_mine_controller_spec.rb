require "spec_helper"

describe WhenToMineController do

  it { should route(:get, '/').to(controller: 'when_to_mine', action: 'index') }

  describe "on GET to #index" do
    before { get :index }
    it { should respond_with(:success) }
  end

end
