class MerchantDiscountsController < ApplicationController

  def index
    @merchant_id = params[:merchant_id]
    @discounts = Merchant.find(params[:merchant_id]).bulk_discounts
    holiday_search = HolidaySearch.new
    @holidays = holiday_search.next_3_holidays
  end

  def show
    @merchant_id = params[:merchant_id]
    @discount = BulkDiscount.find(params[:id])
  end

  def new
    @merchant_id = params[:merchant_id]
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    merchant.bulk_discounts.create!(bulk_discount_params)
    redirect_to "/merchants/#{merchant.id}/discounts"
  end

  def destroy
    discount = BulkDiscount.find(params[:id])
    discount.destroy
    redirect_to "/merchants/#{params[:merchant_id]}/discounts"
  end

  def edit
    @merchant_id = params[:merchant_id]
    @discount = BulkDiscount.find(params[:id])
  end

  def update
    discount = BulkDiscount.find(params[:id])
    discount.update(bulk_discount_params)
    redirect_to "/merchants/#{params[:merchant_id]}/discounts/#{params[:id]}"
  end

  private

    def bulk_discount_params
      params.permit(:percentage, :quantity)
    end
  
end