class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user

  def showstopper(problem)
    flash[:error] = problem
  end

  private
  def current_user
    @current_user ||= User.find_by_email(session[:user_email]) if session[:user_email]
  end
end
