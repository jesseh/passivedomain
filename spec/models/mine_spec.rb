require "spec_helper"

require_dependency Rails.root.join('lib', 'passive_domain').to_s

describe Mine do

  it_behaves_like 'value object'

  let (:data) { PassiveDomain::Interface.for_class(Mine).responder }

  subject { described_class.new(data) }

  #TODO improve these tests
  it { expect(subject.other_cost.to_s).to      be }
  it("", focus: true) { expect(subject.revenue).to              be_an_instance_of(BitcoinRate) }
  it { expect(subject.pool_fees).to            be }
  it { expect(subject.electricity_cost).to     be }

end
