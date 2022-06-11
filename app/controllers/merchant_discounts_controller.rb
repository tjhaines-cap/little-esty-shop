class MerchantDiscountsController < ApplicationController

  def index
    @merchant_id = params[:merchant_id]
    @discounts = Merchant.find(params[:merchant_id]).bulk_discounts
  end

  def show
  end
  
end