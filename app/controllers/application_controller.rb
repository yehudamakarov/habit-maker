class ApplicationController < ActionController::Base

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    !!current_user
  end

  def redirect_because_logged_in
    if logged_in?
      redirect_to user_path(current_user), notice: 'Already logged in.'
    end
  end

  helper_method :current_user, :logged_in?

  def current_user=(user)
    session[:user_id] = user.id
    session[:provider] = auth_hash[:provider]
    @current_user = user
  end
# Why do we makes methods private? Should these be?
  def require_login
    if logged_in?
      return
    else
      redirect_to '/'
    end
  end

  private

  def auth_hash
    @auth_hash ||= request.env["omniauth.auth"]
  end

end
