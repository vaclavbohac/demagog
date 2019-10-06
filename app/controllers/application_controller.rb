# frozen_string_literal: true

Category = Struct.new(:title, :links, keyword_init: true)
Link = Struct.new(:to, :title, :enabled, :permissions, keyword_init: true)

class ApplicationController < ActionController::Base
  before_action :ensure_user_is_active
  before_action :set_raven_context
  before_action :set_paper_trail_whodunnit
  before_action :set_locale

  protect_from_forgery with: :exception

  def menu_items
    MenuItem.order(order: :asc)
  end

  def categories
    [
      Category.new(
        title: "O nás",
        links: [
          Link.new(
            to: experimental_admin_users_path,
            title: "Tým",
            enabled: true,
            permissions: %w[users:view]
          )
        ]
      )
    ]
  end

  protected

  def after_sign_in_path_for(resource)
    request.env["omniauth.origin"] || stored_location_for(resource) || admin_path
  end

  def after_sign_out_path_for(resource)
    admin_path
  end

  def ensure_user_is_active
    # Make sure that we sign out the deactivated user if they are still logged in
    sign_out if current_user && !current_user.active
  end

  def set_raven_context
    Raven.user_context(id: current_user.id, email: current_user.email) if user_signed_in?
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end

  def set_locale
    I18n.locale = I18n.default_locale
  end
end
