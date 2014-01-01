class Api::WhenToMinesController < Api::ApiController

  private

  def store
    WhenToMine::Store.build
  end

  def form
    WhenToMine::Form.new(params[:when_to_mine])
  end

end
