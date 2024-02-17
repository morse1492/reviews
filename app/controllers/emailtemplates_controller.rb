class EmailtemplatesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_emailtemplate, only: [:show, :edit, :update]

  def index
    @emailtemplates = current_user.business.emailtemplates
  end

  def show
  end

  def new
    @emailtemplate = current_user.business.emailtemplates.build
  end

  def create
    @emailtemplate = current_user.business.emailtemplates.build(emailtemplate_params)
    if @emailtemplate.save
      redirect_to emailtemplates_path, notice: 'Email template created successfully.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @emailtemplate.update(emailtemplate_params)
      redirect_to emailtemplates_path, notice: 'Email template updated successfully.'
    else
      render :edit
    end
  end

  private

  def set_emailtemplate
    @emailtemplate = current_user.business.emailtemplates.find(params[:id])
  end
end
