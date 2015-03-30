class SessionsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :create

  def create
    auth = request.env["omniauth.auth"]
    user = User.find_by_provider_and_email(auth["provider"], session[:user_email]) || User.create_with_omniauth(auth, session[:user_email])
    user.update_auth_token(auth)

    redirect_to invoices_path
  end

  def refresh_token
    # Not Implemented Yet.
  end
end
