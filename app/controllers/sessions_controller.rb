class SessionsController < ApplicationController

  def new
  end

  def create
    # avoid double authing and linking rdio with a user
    if (current_user & twitter_auth?) || (!current_user & rdio_auth?)
      redirect_to root_path
    end

    # if twitter than we create the user
    existing_user = if twitter_auth?
      User.find_by_provider_id(:twitter, auth_hash[:uid]) ||
      User.create(
        :name => auth_hash[:info][:name],
        :avatar_url => auth_hash[:info][:image],
        :rotation_size => 8,
        :rotation_frequency => 1
      )
    else
      User.find_by_provider(:rdio, auth_hash[:uid])
    end 

    existing_user.add_provider_from_auth(auth_hash)
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
    redirect_to new_session_path unless user
    
    session[:user_id] = user.id
    redirect_to heavy_rotations_path
  end

  def get_or_create_twitter_user
  end

  def get_or_create_rdio_user
  end

end