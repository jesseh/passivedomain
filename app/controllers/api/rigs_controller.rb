class Api::RigsController < Api::ApiController

  private

  def store
    Rig::Store.build
  end

  def form
    Rig::Form.new(params[:rig])
  end

end
