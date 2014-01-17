require 'spec_helper'


describe 'when to mine cash flow report', type: feature do
  it "can be viewed empty" do
    visit "/when_to_mine/calculator"
    expect(page).to have_content("When to mine")
  end
end


