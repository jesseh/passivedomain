require 'ostruct'

class WhenToMine::CalculatorsController < ApplicationController
  
  def show
    @report = CashFlow::Report.new(data_source.canned)
  end

  private

  def data_source
    CashFlow::DataSource.new
  end
end
