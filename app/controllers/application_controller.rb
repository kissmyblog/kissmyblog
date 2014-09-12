class ApplicationController < ActionController::Base
  helper_method :signed_in?, :current_user

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def authorize
    redirect_to login_url if current_user.nil? || client.nil? || client.login.nil?
  end

  def client
    if current_user
      @client ||= Octokit::Client.new(access_token: current_user['github_token'])
    end
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user
    session['user']
  end
end
