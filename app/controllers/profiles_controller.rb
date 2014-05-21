class ProfilesController < ApplicationController

  def show
    @user = params[:id]
    @profile = User.where(username: @user).first
  end

end
