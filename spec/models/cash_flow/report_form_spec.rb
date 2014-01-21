require "spec_helper"

describe CashFlow::ReportForm do

  let(:data){ {} }
  subject { described_class.new(data) }

  it_should_behave_like "CashFlow::Report data"

end
