require 'rails_helper'

RSpec.describe 'discount edit page' do

  before :each do
    @merch_1 = Merchant.create(name: "Schroeder-Jerde" )
    @merch_2 = Merchant.create(name: "Klein, Rempel and Jones")

    @discount_1 = @merch_1.bulk_discounts.create!(percentage: 20, quantity: 10)
    @discount_2 = @merch_1.bulk_discounts.create!(percentage: 30, quantity: 15)
    @discount_3 = @merch_2.bulk_discounts.create!(percentage: 15, quantity: 5)
  end

  it 'can edit a discount' do
    visit ("/merchants/#{@merch_1.id}/discounts/#{@discount_1.id}/edit")
    
    expect(page).to have_content("Percentage")
    expect(page).to have_content("Quantity threshold")

    fill_in "percentage", with: 10
    fill_in "quantity", with: 5
    click_on "Submit"

    expect(current_path).to eq("/merchants/#{@merch_1.id}/discounts/#{@discount_1.id}")
    expect(page).to have_content("Discount: 10%")
    expect(page).to_not have_content("Discount: 20%")
    expect(page).to have_content("Quantity Threshold: 5")
    expect(page).to_not have_content("Quantity Threshold: 10")
  end

end