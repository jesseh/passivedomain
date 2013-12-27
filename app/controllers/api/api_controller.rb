class Api::ApiController < ApplicationController

  respond_to :json

  def index
    @objects = store.find_all
  end

  def show
    @object = store.find_by_id(params[:id])

    not_found unless @object
  end

  def create
    @object = store.create form
    if @object.persisted?
      render :show
    else
      render :show, status: :not_acceptable
    end
  end

private

  def not_found
    head :not_found
  end

  def form

  end

  def store

  end

end
