# -*- coding: utf-8 -*-

class ApplicationController < ActionController::Base

  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  helper_method :current_user_session, :current_user, :is_admin?
  filter_parameter_logging :password, :password_confirmation
  before_filter :set_locale

  def set_locale
     logger.debug "* Accept-Language: #{request.env['HTTP_ACCEPT_LANGUAGE']}"
     I18n.locale = extract_locale_from_accept_language_header
     logger.debug "* Locale set to '#{I18n.locale}'"
     session[:locale] = params[:locale] if params[:locale]
     I18n.locale = session[:locale] || I18n.default_locale
     I18n.translate('activerecord.errors.messages')

   # I18n.default_locale = 'English'
   # this_domain_lang = request.host.split('.').last

    #if this_domain_lang then
    #  logger.debug "* Accept-Language: #{request.env['HTTP_ACCEPT_LANGUAGE']}"
    #  I18n.locale = extract_locale_from_accept_language_header
    #  I18n.locale = this_domain_lang[1]
    #end

    #if params[:locale] then
    #  logger.debug "* Locale set to '#{I18n.locale}'"
    #  I18n.locale = params[:locale] if params[:locale]
    #  session[:locale] = params[:locale] if params[:locale]
    #  I18n.locale = session[:locale] || I18n.default_locale
    #  I18n.translate('activerecord.errors.messages')
    #end
  end

def logged_in?
    not session[:user_id].nil?
  end

  def logged_out?
    not logged_in?
  end

  def make_profile_vars
    @profile = @user.profile ||= Profile.new
    @blog = @user.blog ||= Blog.new
    @pages, @posts = paginate(@blog.posts, :per_page => 3)
  end

  private

  def extract_locale_from_accept_language_header
    request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
  end

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def is_admin?
    current_user.has_role?("admin")
  end

  def admin_only
    unless is_admin?
      flash[:notice] = "You do not have access to that section"
      redirect_to dashboard_url
    end
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to new_user_session_url
      return false
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def load_user_using_perishable_token
    @user = User.find_using_perishable_token(params[:id], 24.hours)
    unless @user
      flash[:notice] = "We're sorry, but we could not locate your account." +
        "If you are having issues try copying and pasting the URL " +
        "from your email into your browser or restarting the " +
        "reset password process."
      redirect_to root_url
    end
  end

  def param_posted?(sym)
    request.post? and params[sym]
  end


end
