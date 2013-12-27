class Api::RigsController < ApplicationController

  respond_to :json

  def index
    @rigs = store.find_all
  end

  def show
    @rig = store.find_by_id(params[:id])

    not_found unless @rig
  end

  def create
    form = Rig::Form.new(params[:rig])
    @rig = store.create form
    if @rig.persisted?
      render :show
    else
      render :show, status: :not_acceptable
    end
  end

private

  def not_found
    head :not_found
  end

  def store
    Rig::Store
  end

end
