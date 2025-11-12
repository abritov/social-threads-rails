class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  
  # This ensures ActiveStorage::Current.url_options are set for every request
  # It's especially useful when Active Storage URLs are generated outside
  # of a full request cycle (e.g., in views that might be rendered by Turbo,
  # or in background jobs if you extend this setup).
  around_action :set_active_storage_url_options

  private

  def set_active_storage_url_options
    ActiveStorage::Current.url_options = {
      host: request.base_url.sub(/https?:\/\//, ''), # Extract host from current request
      # Add port, protocol if needed. request.base_url usually includes port and protocol.
      # E.g., request.protocol, request.host, request.port
    }

    # If you specifically need to match the development.rb setting, you can do:
    # ActiveStorage::Current.url_options = {
    #   host: Rails.application.config.active_storage.service_urls_host.sub(/https?:\/\//, ''),
    #   protocol: "http", # Or "https" if applicable
    #   port: 3002 # Or request.port
    # }

    # For development, you can simplify to use the development.rb setting
    if Rails.env.development?
      ActiveStorage::Current.url_options = { host: "localhost", port: 3002, protocol: "http" }
    elsif Rails.env.production?
      ActiveStorage::Current.url_options = { host: "your-app-domain.com", protocol: "https", port: nil } # Adjust for production
    else # test environment etc.
      ActiveStorage::Current.url_options = Rails.application.config.action_controller.default_url_options
    end

    yield
  ensure
    # Reset to nil after the request to avoid cross-request contamination
    ActiveStorage::Current.url_options = nil
  end
end
