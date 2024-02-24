class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters

  def new
    super do |resource|
      resource.build_business # Prepares a new business for the form
    end
  end

  def create
    super do |resource|
      if resource.save
        # Here, you might create or associate the business with the user.
        # This is just a placeholder; actual implementation depends on your form and model setup.
      end
    end
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [business_attributes: [:business_name, :contact_info, :email, :google_place_id, :yelp_business_id]])
  end
end
