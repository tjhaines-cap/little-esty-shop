class MerchantDiscountsController < ApplicationController

  def index
    @merchant_id = params[:merchant_id]
    @discounts = Merchant.find(params[:merchant_id]).bulk_discounts
  end

  def show
  end

  def new
    @merchant_id = params[:merchant_id]
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    merchant.bulk_discounts.create!(bulk_discount_params)
    redirect_to "/merchants/#{merchant.id}/discounts"
  end

  private

    def bulk_discount_params
      params.permit(:percentage, :quantity)
    end
  
end