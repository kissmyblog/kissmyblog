class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def authorize
    redirect_to login_url if current_user.nil? || client.nil? || client.login.nil?
  end

  def client
    if current_user
      @client ||= Octokit::Client.new(access_token: current_user['token'])
    end
  end

  def current_user
    session['github_user']
  end
end
