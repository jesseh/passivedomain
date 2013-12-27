shared_examples "API GET #index" do
  let(:objects) { [double("obj1"), double("obj2"), double("obj3")] }

  before do
    allow(store).to receive(:find_all){ objects }

    get :index
  end

  it { should respond_with(:success) }
  it { expect(store).to have_received(:find_all) }
end

shared_examples "API GET #show" do
  context "for a rig that exists" do
    let(:obj) { double("Obj", :to_param => 10) }

    before do
      allow(store).to receive(:find_by_id){ obj }

      get :show, :id => obj.to_param
    end

    it { should respond_with(:success) }
    it { expect(store).to have_received(:find_by_id).with("10") }
  end

  context "for a rig that does not exist" do
    before do
      allow(store).to receive(:find_by_id){ nil }

      get :show, :id => "missing"
    end

    it { should respond_with(:not_found) }
  end
end

shared_examples "API POST #create" do
  let(:model){ double "model", persisted?: valid }
  let(:form){ double "form" }
  let(:params){ {'stuff' => 'abc'} }
  let(:full_params){ {:obj => params} }
  let(:valid){ true }

  before do
    allow( form_class ).to receive(:new){ form }
    allow( store ).to receive(:create){ model }

    post :create, full_params
  end

  context "for a valid rig" do
    it { should respond_with(:success) }
    it { expect(form_class).to have_received(:new).with(params) }
    it { expect(store).to have_received(:create).with(form) }
  end

  context "for an invalid rig" do
    let(:valid){ false }
    it { should respond_with(:not_acceptable) }
  end
end
