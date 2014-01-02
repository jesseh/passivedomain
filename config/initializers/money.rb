usd_currency = {
  :priority        => 2,
  :iso_code        => "USD",
  :iso_numeric     => "840",
  :name            => "United States Dollar",
  :symbol          => "$",
  :subunit         => "Cent",
  :subunit_to_unit => 100,
  :separator       => ".",
  :delimiter       => ","
}

bitcoin_currency = {
  :priority        => 1,
  :iso_code        => "BTC",
  :name            => "Bitcoin",
  :symbol          => "B",
  :subunit_to_unit => 1,
  :separator       => ".",
  :delimiter       => ","
}

Money::Currency.register(usd_currency)
Money::Currency.register(bitcoin_currency)

# Bitcoin can have small decimal numbers
Money.infinite_precision = true
