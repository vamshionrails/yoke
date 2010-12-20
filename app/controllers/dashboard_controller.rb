class DashboardController < ApplicationController

  theme APP_THEME
  before_filter :require_user


  def show
    @user = current_user
    @videos = Video.find_all_by_user_id(current_user)
  end

end
