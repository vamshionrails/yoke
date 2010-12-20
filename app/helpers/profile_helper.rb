module ProfileHelper

def profile_for(user)
    profile_url(:screen_name => user.login)
  end

end
