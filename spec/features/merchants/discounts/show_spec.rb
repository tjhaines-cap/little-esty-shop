require 'rails_helper'

RSpec.describe 'discount show page', type: :feature do

  it 'displays discount percentage and quantity threshold' do
    merch_1 = Merchant.create(name: "Schroeder-Jerde" )
    merch_2 = Merchant.create(name: "Klein, Rempel and Jones")

    discount_1 = merch_1.bulk_discounts.create!(percentage: 20, quantity: 10)
    discount_2 = merch_1.bulk_discounts.create!(percentage: 30, quantity: 15)
    discount_3 = merch_2.bulk_discounts.create!(percentage: 15, quantity: 5)
 
    visit "/merchants/#{merch_1.id}/discounts/#{discount_1.id}"

    expect(page).to have_content("Percentage: 20%")
    expect(page).to have_content("Quantity Threshold: 10")
    expect(page).to_not have_content("Percentage: 30%")
    expect(page).to_not have_content("Quantity Threshold: 15")
    expect(page).to_not have_content("Percentage: 15%")
    expect(page).to_not have_content("Quantity Threshold: 5")
  end
end