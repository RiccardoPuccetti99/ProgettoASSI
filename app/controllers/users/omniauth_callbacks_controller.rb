class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token

    def google_oauth2
      @user = User.from_omniauth(request.env["omniauth.auth"])
      access_token = request.env["omniauth.auth"].credentials.token
      @user.update(token: access_token)
  
      if @user.persisted?
        sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
        set_flash_message(:notice, :success, :kind => "Google") if is_navigational_format?
      else
        #flash[:error] = "There was a problem signing you in through Google. Please register or try signing in later"
        session["devise.google_data"] = request.env["omniauth.auth"].except(:extra) # Removing extra as it can overflow some session stores
        redirect_to new_user_registration_url
      end
    end
  
    def failure
      redirect_to root_path
    end
  end