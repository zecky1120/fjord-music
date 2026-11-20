Rails.application.config.middleware.use OmniAuth::Builder do
  provider :discord,
  Rails.application.credentials.discord[:client_id],
  Rails.application.credentials.discord[:client_secret],
  scope: 'identify'

  OmniAuth.config.on_failure = proc { |_env| [ 302, { 'Location' => '/auth/failure', 'Content-Type' => 'text/html' }, [] ] }
end
