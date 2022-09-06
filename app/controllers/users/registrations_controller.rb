class Users::RegistrationsController < Devise::RegistrationsController
    before_action :configure_sign_up_params, only: [:create]

    respond_to :json
  
    private
  
    def configure_sign_up_params
        devise_parameter_sanitizer.permit(:sign_up, keys: [:role, :name, :email, :weight, :password, :password_confirmation, :age])
    end

    def respond_with(resource, _opts = {})
      register_success && return if resource.persisted?

      register_failed
    end
  
    def register_success
      # UserMailer.with(user: current_user ).welcome_email.deliver_later
      render json: { message: 'Signed up sucessfully.' }
    end
  
    def register_failed
      render json: { message: "Something went wrong." }
    end
  
  end