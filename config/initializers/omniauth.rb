Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  provider :twitter, RotateRadio::Application.config.creds["twitter"]["consumer_key"], RotateRadio::Application.config.creds["twitter"]["consumer_secret"]
  provider :rdio, RotateRadio::Application.config.creds["rdio"]["consumer_key"], RotateRadio::Application.config.creds["rdio"]["consumer_secret"]
end

p 