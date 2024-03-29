module RigOrig

  class Form
    include ActiveModel::Model

    attr_reader   :rig
    attr_accessor :name, :price_fractional, :power, :hash_rate

    validates_presence_of :name
    validates_numericality_of :price_fractional, only_integer: true, greater_than_or_equal_to: 0
    validates_numericality_of :hash_rate, greater_than: 0
    validates_numericality_of :power, only_integer: true, greater_than: 0

    def initialize(params={})
      hash = params.with_indifferent_access

      self.name             = hash[:name]
      self.price_fractional = hash[:price_fractional]
      self.power            = hash[:power]
      self.hash_rate        = hash[:hash_rate]
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
