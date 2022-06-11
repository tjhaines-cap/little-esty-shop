require 'rails_helper'

RSpec.describe 'Discount new page' do

  it 'can create a new discount' do
    merch_1 = Merchant.create(name: "Schroeder-Jerde" )
    
    visit "/merchants/#{merch_1.id}/discounts/new"

    fill_in "percentage", with: 40
    fill_in "quantity", with: 20
    click_button "Create Discount"

    expect(current_path).to eq("/merchants/#{merch_1.id}/discounts")

    within "#discount-0" do
      expect(page).to have_content("Discount 1: 40%")
      expect(page).to have_content("Quantity Threshold: 20")
    end
  end
end