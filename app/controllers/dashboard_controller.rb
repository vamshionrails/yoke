class DashboardController < ApplicationController

  theme APP_THEME
  before_filter :require_user


  def show
    @user = current_user
    @videos = @user.videos
  end

end
