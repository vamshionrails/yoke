class Admin::IndexController < ApplicationController
 theme ADMIN_THEME
  before_filter :require_user

  def index
  end

  def jobs
    @jobs = DelayedJob.find(:all)
  end

  def show
  end

end
