class SessionsController < ApplicationController
  def create
    auth = request.env['omniauth.auth']
    session[:github_user] = {
      'login' => auth['info']['nickname'],
      'name'  => auth['info']['name'],
      'token' => auth['credentials']['token']
    }
    redirect_to root_path
  end

  def destroy
    session['github_user'] = nil
    redirect_to root_url, notice: 'Logged out!'
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end