require 'ostruct'

class WhenToMine::CalculatorsController < ApplicationController
  
  def show
    data = data_source.canned
    @form = CashFlow::FormBacker.new params
    @report = CashFlow::Report.create(data)
    @rig = Rig.new(data)
    @network = Network.new(data)
    @exchange = Exchange.new(data)
  end

  def create
    @form = CashFlow::FormBacker.new params
    @report = CashFlow::Report.create(data)
    @rig = Rig.new(data)
    @network = Network.new(data)
    @exchange = Exchange.new(data)
    render 'show'
  end

  private

  def data_source
    CashFlow::DataSource.new
  end
end
