class UsersController < ApplicationController

  before_filter :ensure_logged_in

  def update
    user = User.find_by_id(params[:id])
    user.update_attributes(params.slice(:rotation_status))

    render :json => user
  end

end
