EMAIL_CONFIG = YAML.load_file("#{::Rails.root}/config/email.yml")[::Rails.env]

ActionMailer::Base.smtp_settings = {
  :address              => EMAIL_CONFIG['address'],
  :port                 => EMAIL_CONFIG['port'],
  :domain               => EMAIL_CONFIG['domain'],
  :user_name            => EMAIL_CONFIG['user_name'],
  :password             => EMAIL_CONFIG['password'],
  :authentication       => EMAIL_CONFIG['authentication'],
  :enable_starttls_auto => EMAIL_CONFIG['enable_starttls_auto'],
}

