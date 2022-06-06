require 'rails_helper'

RSpec.describe 'merchant items index page' do
  before :each do
    @merch_1 = Merchant.create!(name: "Two-Legs Fashion")
    @merch_2 = Merchant.create!(name: "One-Legs Fashion")

    @item_1 = @merch_1.items.create!(name: "Two-Leg Pantaloons", description: "pants built for people with two legs", unit_price: 5000)
    @item_2 = @merch_1.items.create!(name: "Two-Leg Shorts", description: "shorts built for people with two legs", unit_price: 3000)
    @item_3 = @merch_1.items.create!(name: "Hat", description: "hat built for people with two legs and one head", unit_price: 6000)
    @item_4 = @merch_1.items.create!(name: "Double Legged Pant", description: "pants built for people with two legs", unit_price: 50000)
    @item_5 = @merch_1.items.create!(name: "Stainless Steel, 5-Pocket Jean", description: "Shorts of Steel", unit_price: 3000000)
    @item_6 = @merch_1.items.create!(name: "String of Numbers", description: "54921752964273", unit_price: 100)
    @item_7 = @merch_2.items.create!(name: "Pirate Pants", description: "Peg legs don't need pant legs", unit_price: 1000)

  end

  it 'displays a list of the names of all the merchants items and none from any other merchant' do
    visit "merchants/#{@merch_1.id}/items"
    expect(page).to have_content("Two-Leg Pantaloons")
    expect(page).to have_content("Two-Leg Shorts")
    expect(page).to have_content("Hat")
    expect(page).to have_content("Double Legged Pant")
    expect(page).to have_content("Stainless Steel, 5-Pocket Jean")
    expect(page).to have_content("String of Numbers")
    expect(page).to_not have_content("Pirate Pants")
  end

  it 'can disable/enable an item and the items are separated and displayed by status' do
    visit "/merchants/#{@merch_1.id}/items"
    within "#disabled" do
      within "#item-#{@item_1.id}" do
        expect(page).to_not have_button("Disable")
        click_button("Enable")
        expect(current_path).to eq("/merchants/#{@merch_1.id}/items")
      end
    end
    within "#enabled" do
      within "#item-#{@item_1.id}" do
        expect(page).to_not have_button("Enable")
        click_button("Disable")
        expect(current_path).to eq("/merchants/#{@merch_1.id}/items")
      end
    end
  end

  it 'has a link to create a new item' do
    visit "/merchants/#{@merch_1.id}/items"
    click_link("New Item")
    expect(current_path).to eq("/merchants/#{@merch_1.id}/items/new")
  end

  it "displays 5 most popular items and their best selling date" do
    merch1 = Merchant.create!(name: 'Merch1')
    merch2 = Merchant.create!(name: 'Merch2')

    item1 = merch1.items.create!(name: 'item1', description: 'test item1', unit_price: 100)
    item2 = merch1.items.create!(name: 'item2', description: 'test item2', unit_price: 100)
    item3 = merch1.items.create!(name: 'item3', description: 'test item3', unit_price: 100)
    item4 = merch1.items.create!(name: 'item4', description: 'test item4', unit_price: 100)
    item5 = merch1.items.create!(name: 'item5', description: 'test item5', unit_price: 100)
    item6 = merch1.items.create!(name: 'item6', description: 'test item6', unit_price: 100)

    item7 = merch2.items.create!(name: 'item7', description: 'test item7', unit_price: 100)
    item8 = merch2.items.create!(name: 'item8', description: 'test item8', unit_price: 100)
    item9 = merch2.items.create!(name: 'item9', description: 'test item9', unit_price: 100)
    item10 = merch2.items.create!(name: 'item10', description: 'test item10', unit_price: 100)
    item11 = merch2.items.create!(name: 'item11', description: 'test item11', unit_price: 100)
    item12 = merch2.items.create!(name: 'item12', description: 'test item12', unit_price: 100)

    cust1 = Customer.create!(first_name: 'Cory', last_name: 'Bethune')
    cust2 = Customer.create!(first_name: 'Billy', last_name: 'Bob')

    invoice1 = cust1.invoices.create!(status: 2)
    invoice2 = cust2.invoices.create!(status: 2)

    trans1 = invoice1.transactions.create!(credit_card_number: '0000111122223333', result: 'success')
    trans2 = invoice2.transactions.create!(credit_card_number: '4444555566667777', result: 'success')

    ii1 = InvoiceItem.create!(quantity: 10, unit_price: 100, status: 2, item_id: item1.id, invoice_id: invoice1.id)
    ii2 = InvoiceItem.create!(quantity: 2, unit_price: 100, status: 2, item_id: item2.id, invoice_id: invoice1.id)
    ii3 = InvoiceItem.create!(quantity: 5, unit_price: 100, status: 2, item_id: item3.id, invoice_id: invoice1.id)
    ii4 = InvoiceItem.create!(quantity: 20, unit_price: 100, status: 2, item_id: item4.id, invoice_id: invoice1.id)
    ii5 = InvoiceItem.create!(quantity: 100, unit_price: 100, status: 2, item_id: item5.id, invoice_id: invoice1.id)
    ii6 = InvoiceItem.create!(quantity: 1, unit_price: 100, status: 2, item_id: item6.id, invoice_id: invoice1.id)

    ii7 = InvoiceItem.create!(quantity: 1, unit_price: 100, status: 2, item_id: item7.id, invoice_id: invoice2.id)
    ii8 = InvoiceItem.create!(quantity: 12, unit_price: 100, status: 2, item_id: item8.id, invoice_id: invoice2.id)
    ii9 = InvoiceItem.create!(quantity: 13, unit_price: 100, status: 2, item_id: item9.id, invoice_id: invoice2.id)
    ii10 = InvoiceItem.create!(quantity: 100, unit_price: 100, status: 2, item_id: item10.id, invoice_id: invoice2.id)
    ii11 = InvoiceItem.create!(quantity: 5, unit_price: 100, status: 2, item_id: item11.id, invoice_id: invoice2.id)
    ii12 = InvoiceItem.create!(quantity: 0, unit_price: 100, status: 2, item_id: item12.id, invoice_id: invoice2.id)



    visit "/merchants/#{@merch_1.id}/items"
    # save_and_open_page
    # binding.pry
      within "favorite" do
        expect(page).to have_content("Top 5 Most Popular Items")
        expect(page).to have_content("Top selling date for #{item1.name} was #{item1.created_at}")
      end
  end
end
