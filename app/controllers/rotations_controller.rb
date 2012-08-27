class RotationsController < ApplicationController

  before_filter :ensure_logged_in

  def index
    rotations = if params[:user_id]
      User.find(params[:user_id]).rotations
    else
      Rotations.all
    end
    
    render :json => rotations.reverse_order
  end

  def show
    rotation = current_user.rotations.find_by_id(params[:id])

    if rotation
      render :json => rotation
    else
      head :not_found
    end
  end

  def refresh
    new_rotation = current_user.refresh_rotation
    
    if new_rotation
      render :json => next_rotation
    else
      head :no_content
    end
  end

end
