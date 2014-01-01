class Api::CashFlowsController < Api::ApiController

  private

  def store
    CashFlow::Store.build
  end

  def form
    CashFlow::Form.new(params[:cash_flow])
  end

end
