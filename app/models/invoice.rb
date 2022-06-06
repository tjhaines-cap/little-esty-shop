class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :transactions, dependent: :destroy
  has_many :invoice_items
  has_many :items, through: :invoice_items

  enum status: ['cancelled','in progress', 'completed']

  validates :status, inclusion: { in: statuses.keys }

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def self.incomplete_invoices_ordered
    Invoice.joins(:invoice_items).where(invoice_items: { status: [0, 1] }).order(:created_at).distinct
  end

  def top_5_items_by_day
    joins(:invoice_items, :invoices, :transactions)
    .where("transactions.status = 'success', invoices.status = 2")
    .select("invoice_items.quantity, items.name")
    .group(:id)
    .order(:quantity)
    .distinct
    .limit(5)
  end
end
