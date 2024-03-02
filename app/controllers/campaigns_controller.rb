class CampaignsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_campaign, only: [:show, :edit, :update, :destroy]


  def index
    @campaigns = current_user.business.campaigns
  end

  def show
  end

  def new
    @business = Business.find(params[:business_id])
    @campaign = current_user.business.campaigns.build
  end

  def create
    @campaign = current_user.business.campaigns.build(campaign_params)
    if @campaign.save
      redirect_to root_path, notice: 'Campaign created successfully.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @campaign.update(campaign_params)
      redirect_to business_campaign_path, notice: 'Campaign updated successfully.'
    else
      render :edit
    end
  end

  def destroy
    @campaign.destroy
    redirect_to business_campaign_path, notice: 'Campaign deleted successfully.'
  end

  private

  def set_campaign
    @campaign = current_user.business.campaigns.find(params[:id])
  end

  def campaign_params
    params.require(:campaign).permit(:name, :delaytime)
  end
end
