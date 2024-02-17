class Users::RegistrationsController < Devise::RegistrationsController
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

  def sign_up_params
    # Ensure you permit business attributes for creation
    params.require(:user).permit(:email, :password, :password_confirmation, business_attributes: [:business_name, :contact_info])
  end
end
