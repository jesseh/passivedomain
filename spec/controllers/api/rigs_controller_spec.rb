require "spec_helper"

describe Api::RigsController do

  it { should route(:get, '/api/rigs').to(controller: 'api/rigs', action: 'index') }
  it { should route(:get, '/api/rigs/1').to(controller: 'api/rigs', action: 'show', id: '1') }

  before do
    stub_const('Rig::Store', double('Rig::Store'))
  end

  describe "GET #index" do
    let(:rigs) { [double("rig1"), double("rig2"), double("rig3")] }

    before do
      allow(Rig::Store).to receive(:find_all){ rigs }

      get :index
    end

    it { should respond_with(:success) }
    it { expect(Rig::Store).to have_received(:find_all) }
  end

  describe "GET #show" do
    context "for a rig that exists" do
      let(:rig) { double("Rig", :to_param => 10) }

      before do
        allow(Rig::Store).to receive(:find_by_id){ rig }

        get :show, :id => rig.to_param
      end

      it { should respond_with(:success) }
      it { expect(Rig::Store).to have_received(:find_by_id).with("10") }
    end

    context "for a rig that does not exist" do
      before do
        allow(Rig::Store).to receive(:find_by_id){ nil }

        get :show, :id => "missing"
      end

      it { should respond_with(:not_found) }
    end
  end
end
