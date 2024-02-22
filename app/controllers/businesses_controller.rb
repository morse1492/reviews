class BusinessesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_business, only: [:show, :edit, :update]

  def show
  end

  def edit
  end

  def update
    if @business.update(business_params)
      redirect_to @business, notice: 'Business details updated successfully.'
    else
      render :edit
    end
  end

  private

  def set_business
    @business = current_user.business
  end

  def business_params
    params.require(:business).permit(:business_name, :contact_info, :email, :google_place_id)
  end
end
