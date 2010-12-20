class ProfileController < ApplicationController
 theme APP_THEME
  def index
    @title = "Yoke Profiles"
    @user.profile ||= Profile.new
    @profile = @user.profile

  end
  def show
    @user = current_user
    @user.profile ||= Profile.new
    @profile = @user.profile

    if param_posted?(:spec)
      if @user.profile.update_attributes(params[:profile])
        flash[:notice] = "Changes saved."
        redirect_to :controller => "user", :action => "index"
      end
    end
    if @user
      @title = "Yoke::MyProfile"
    else
      flash [:notice] => "error!"
    end
  end

# Edit the user's profile.
  def edit
    @title = "Edit Profile"
    @user = current_user
    @user.profile ||= Profile.new
    @profile = @user.profile
    if param_posted?(:profile)
      if @user.profile.update_attributes(params[:profile])
        flash[:notice] = "Changes saved."

      end
    end
  end

end
