class RotationsController < ApplicationController

  before_filter :ensure_logged_in

  def index
    rotation_type = params[:type] == 'latest' ? :latest : :standard

    rotations = if rotation_type == :latest
      current_user.rotations.reverse_order.limit(1)
    else
      current_user.rotations
    end
    
    render :json => rotations
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
