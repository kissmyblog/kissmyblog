Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, Rails.application.secrets.omniauth_gh_key, Rails.application.secrets.omniauth_gh_secret, scope: "user, public_repo"
end
