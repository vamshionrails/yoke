class ProfileController < ApplicationController
 theme APP_THEME


def index
    @title = "Yoke::Profiles"
  redirect_to :controller => "user", :action => "index"
  end

  def show
    @hide_edit_links = true
    login = params[:login]
    @user = User.find_by_login(login)
    if @user
      @title = "My Yoke::Profile for #{login}"
      @profile = @user.profile ||= Profile.new

    else
      flash[:notice] = "No user #{login} at Yoke::Profile!"
      redirect_to :action => "index"
    end
  end


# Edit the user's spec.
  def edit
    @title = "Edit Profile"
    @user = current_user
    @user.profile ||= Profile.new
    @profile = @user.profile
    if param_posted?(:profile)
      if @user.profile.update_attributes(params[:profile])
        flash[:notice] = "Changes saved."
       # redirect_to :controller => "profile", :action => "index"
      end
    end
  end






end
