class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :transactions, dependent: :destroy
  has_many :invoice_items
  has_many :items, through: :invoice_items
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

  def discounted_revenue
    # #find the bulk discount for one invoice itme
    # # bulk_discounts.find_by("bulk_discounts.quantity >= #{invoice_items[0].quantity}")
    # invoice_items.discounted_revenue
    # wip = invoice_items.where("quantity > #{bulk_discounts.minimum(:quantity)}")
    # binding.pry
    #             .sum("(quantity * unit_price) * #{bulk_discounts.find_by("bulk_discounts.quantity >= #{invoice_items.quantity}")}")           
    # #  .select("invoice_items.*, sum(invoice_items.discounted_revenue)").group(:id)
    sum = 0
    if bulk_discounts != []
      invoice_items.each do |invoice_item|
        discount = invoice_item.discount_applied[0]
        if discount
          sum += (invoice_item.quantity * invoice_item.unit_price) * ((100 - discount.percentage) / 100.0)
        else
          sum += (invoice_item.quantity * invoice_item.unit_price)
        end
      end
    end
    return sum
  end

  def total_revenue_by_merchant(merchant_id)
    invoice_items.where(item_id: Merchant.find(merchant_id).items.ids).sum("unit_price * quantity")
  end

  def discounted_revenue_by_merchant(merchant_id)
    sum = 0
    if bulk_discounts != []
      invoice_items.where(item_id: Merchant.find(merchant_id).items.ids).each do |invoice_item|
        discount = invoice_item.discount_applied[0]
        if discount
          sum += (invoice_item.quantity * invoice_item.unit_price) * ((100 - discount.percentage) / 100.0)
        else
          sum += (invoice_item.quantity * invoice_item.unit_price)
        end
      end
    end
    return sum
    # bulk_discounts.where(merchant_id: merchant_id).where("invoice_items.quantity >= bulk_discounts.quantity").order(percentage: :desc).limit(1)
    # wip = invoice_items.where(item_id: Merchant.find(merchant_id).items.ids)
    # binding.pry
    # .sum("(quantity * unit_price) * ((100 - #{invoice_items.discount_applied}) / 100.0)")
    # .sum("(quantity * unit_price) * ((100 - #{bulk_discounts.where(merchant_id: merchant_id).where("invoice_items.quantity >= bulk_discounts.quantity").order(percentage: :desc).limit(1)[0].percentage}) / 100.0)")
    # .sum("(quantity * unit_price) * ((100 - invoice_items.discount) / 100)")
    # binding.pry
  end


end
