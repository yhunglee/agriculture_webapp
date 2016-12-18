Recaptcha.configure do |config|
	config.site_key = Rails.application.secrets.recaptcha_public_key
	config.secret_key = Rails.application.secrets.recaptcha_secret_key
end 
