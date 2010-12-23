module ProfileHelper


def profile_for(user)
    profile_url(:login => user.login)
  end

  def hide_edit_links?
    not @hide_edit_links.nil?
  end
end
