Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load
  # config.action_controller.asset_host = 'https://d1monvl96vvqbd.cloudfront.net'

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  # config.assets.debug = true

  # Asset digests allow you to set far-future HTTP expiration dates on all assets,
  # yet still be able to expire them through the digest params.
  config.assets.digest = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true
  config.action_mailer.delivery_method = :smtp
  host = 'lmcation.com' #replace with your own url
  config.action_mailer.default_url_options = { host: host }

  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_deliveries = true
  # SMTP settings for gmail
  config.action_mailer.smtp_settings = {
    :address              => "smtp.gmail.com",
    :port                 => 587,
    :domain => "gmail.com",
    :openssl_verify_mode => 'none',
    :user_name            => Rails.application.secrets.gmail_email,
    :password             => Rails.application.secrets.gmail_password,
    :authentication       => "plain",
    :enable_starttls_auto => true
  }
  config.paperclip_defaults = {
    # storage: :cloudinary,
    # url: ':cloudinary_domain_url',
    # path: ':filename',
    # cloudinary_credentials: Rails.root.join("config/cloudinary.yml"),
    storage: :s3,
    s3_protocol: :https,
    url: ':s3_alias_url',
    s3_host_alias: "d1monvl96vvqbd.cloudfront.net",
    path: '/:class/:attachment/:id_partition/:style/:filename',
    s3_credentials: {
      bucket: "lmcation",
      access_key_id: "AKIAVOA7O3QTCMF32FCF",
      secret_access_key: "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",
      s3_region: "ap-southeast-1"
    }
  }

  config.static_cache_control = "public, max-age=3600"
end
