module Rig

  class Form
    include ActiveModel::Model

    attr_reader   :rig
    attr_accessor :name, :price_fractional, :power, :hash_rate

    validates_presence_of :name
    validates_numericality_of :price_fractional, only_integer: true, greater_than_or_equal_to: 0
    validates_numericality_of :hash_rate, greater_than: 0
    validates_numericality_of :power, only_integer: true, greater_than: 0

    def initialize(params={})
      self.name             = params[:name]
      self.price_fractional = params[:price_fractional]
      self.power            = params[:power]
      self.hash_rate        = params[:hash_rate]
    end

    def attributes
      {
        name:             name,
        price_fractional: price_fractional,
        power:            power,
        hash_rate:        hash_rate
      }
    end

    def persisted?
      false
    end

    def price_currency
      "USD"
    end
  end

end
