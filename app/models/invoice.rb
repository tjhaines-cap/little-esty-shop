class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :transactions, dependent: :destroy
  has_many :invoice_items
  has_many :items, through: :invoice_items

  #add test if i keep it in
  has_many :bulk_discounts, through: :items

  enum status: ['cancelled','in progress', 'completed']

  validates :status, inclusion: { in: statuses.keys }

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def self.incomplete_invoices_ordered
    Invoice.joins(:invoice_items).where(invoice_items: { status: [0, 1] }).order(:created_at).distinct
  end

  def merchant_object(id)
    Merchant.find(id)
  end

  def regular_revenue
    # binding.pry
    invoice_items.where("quantity < #{bulk_discounts.minimum(:quantity)}")
                  .sum("unit_price * quantity")
    # invoice_items.regular_revenue
    # #find min quantity
    # bulk_discounts.minimum(:quantity)
    # #access bulk discounts for merchant for item
    # invoice_items[0].item.merchant.bulk_discounts
  end
end
