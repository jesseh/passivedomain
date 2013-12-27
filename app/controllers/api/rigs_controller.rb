class Api::RigsController < ApplicationController

  respond_to :json

  def index
    @rigs = Rig::Store.find_all
  end

  def show
    @rig = Rig::Store.find_by_id(params[:id])

    not_found unless @rig
  end

private

  def not_found
    head :not_found
  end

end
