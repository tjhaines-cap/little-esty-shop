require 'rails_helper' 

RSpec.describe 'merchant discounts index page' do

  before :each do
    @merch_1 = Merchant.create(name: "Schroeder-Jerde" )
    @merch_2 = Merchant.create(name: "Klein, Rempel and Jones")

    @discount_1 = @merch_1.bulk_discounts.create!(percentage: 20, quantity: 10)
    @discount_2 = @merch_1.bulk_discounts.create!(percentage: 30, quantity: 15)
    @discount_3 = @merch_2.bulk_discounts.create!(percentage: 15, quantity: 5)
  end

  it 'displays all bulk discounts for merchant including link to show page' do
    visit "/merchants/#{@merch_1.id}/discounts"

    within "#discount-0" do
      expect(page).to have_content("Discount 1: 20%")
      expect(page).to have_content("Quantity Threshold: 10")
      click_link("Discount 1")
      expect(current_path).to eq("/merchants/#{@merch_1.id}/discounts/#{@discount_1.id}")
      visit "/merchants/#{@merch_1.id}/discounts"
    end
    within "#discount-1" do
      expect(page).to have_content("Discount 2: 30%")
      expect(page).to have_content("Quantity Threshold: 15")
      click_link("Discount 2")
      expect(current_path).to eq("/merchants/#{@merch_1.id}/discounts/#{@discount_2.id}")
      visit "/merchants/#{@merch_1.id}/discounts"
    end
    expect(page).to_not have_content("Discount: 15%")
    expect(page).to_not have_content("Quanitity Threshold: 5")
  end

  it 'has a link to create a new discount' do
    visit "/merchants/#{@merch_1.id}/discounts"

    click_link("Create New Discount")

    expect(current_path).to eq("/merchants/#{@merch_1.id}/discounts/new")
  end

  it 'had a delete button next to each discount' do
    visit "/merchants/#{@merch_1.id}/discounts"

    click_button("Delete Discount 1")

    expect(current_path).to eq("/merchants/#{@merch_1.id}/discounts")
    within "#discount-0" do
      expect(page).to have_content("Discount 2: 30%")
      expect(page).to have_content("Quantity Threshold: 15")
      click_link("Discount 2")
      expect(current_path).to eq("/merchants/#{@merch_1.id}/discounts/#{@discount_2.id}")
      visit "/merchants/#{@merch_1.id}/discounts"
    end
    expect(page).to_not have_content("Discount 1: 20%")
    expect(page).to_not have_content("Quantity Threshold: 10")
  end
end