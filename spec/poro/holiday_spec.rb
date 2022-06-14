require 'rails_helper'

RSpec.describe Holiday do

  it "exists and has readable attributes" do
    christmas = Holiday.new({name: "Christmas", date: "12/25/2022"})

    expect(christmas.name).to eq("Christmas")
    expect(christmas.date).to eq("12/25/2022")
  end
end