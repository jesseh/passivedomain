require 'ostruct'

class WhenToMine::CalculatorsController < ApplicationController
  
  def show
    mapper = CashFlow::Mapper.new
    CashFlow::DataSource.new(mapper).canned

    @report = CashFlow::Report.new(mapper)
    @yada = 'yeehaa'
  end

end
