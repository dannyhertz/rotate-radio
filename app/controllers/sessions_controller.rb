class SessionsController < ApplicationController

  before_filter :prevent_double_auth, :only => [:new, :create]

  def new
  end

  def create
    existing_user = current_user || User.find_by_provider_auth(auth_hash)
    
    unless existing_user
      existing_user = User.create_from_provider_auth(auth_hash)
    end
    existing_user.add_provider_from_auth(auth_hash)
    
    if current_user && current_user.fully_authed?
      redirect_to root_path
    else
      log_user_in(existing_user)
      redirect_to new_session_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to new_session_path
  end

  protected

  def twitter_auth?
    params[:provider] == "twitter"
  end

  def rdio_auth?
    params[:provider] == "rdio"
  end

  def auth_hash
    request.env['omniauth.auth']
  end

  def log_user_in(user)
    redirect_to new_session_path and return unless user
    session[:user_id] = user.id
  end

  def prevent_double_auth
    redirect_to root_path if current_user && current_user.fully_authed?
  end

end