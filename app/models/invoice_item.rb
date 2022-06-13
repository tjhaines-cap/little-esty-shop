class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice

  has_many :bulk_discounts, through: :item

  validates_presence_of :quantity, :unit_price

  enum status: ['packaged', 'pending', 'shipped']

  validates :status, inclusion: { in: statuses.keys }

  def discount
    bulk_discounts.where("#{quantity} >= bulk_discounts.quantity")
                  .order(percentage: :desc)
                  .limit(1)
  end
end