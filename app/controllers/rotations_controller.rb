class RotationsController < ApplicationController

  before_filter :ensure_logged_in

  def index
    latest_rotation = current_user.rotations.last

    render :json => { :latest_rotation => latest_rotation }
  end

  def show
    rotation = current_user.rotations.find_by_id(params[:id])

    if rotation
      render :json => rotation
    else
      head :not_found
    end
  end

end
