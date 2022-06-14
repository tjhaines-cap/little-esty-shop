require 'rails_helper'

RSpec.describe Repo do

  it "exists and has readable attributes" do
    little_esty = Repo.new({name: "little esty shop"})

    expect(little_esty.name).to eq("little esty shop")
  end
end