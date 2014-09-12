class SessionsController < ApplicationController
  def create
    auth = request.env['omniauth.auth']
    session[:user] = {
      'login' => auth['info']['nickname'],
      'image' => auth['info']['image'],
      'github_token' => auth['credentials']['token']
    }
    redirect_to repositories_path
  end

  def destroy
    session['user'] = nil
    redirect_to root_url, notice: 'Logged out!'
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end