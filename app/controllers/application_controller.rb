class ApplicationController < ActionController::Base
  protect_from_forgery

  protected

  def current_user
    User.find_by_id(session[:user_id])
  end

  def ensure_logged_in
    redirect_to new_session_path unless current_user
  end
end
