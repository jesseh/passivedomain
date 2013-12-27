class Api::ProblemsController < Api::ApiController

  private

  def store
    Problem::Store.build
  end

  def form
    Problem::Form.new(params[:problem])
  end

end
