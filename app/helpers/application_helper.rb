# frozen_string_literal: true

require "uri"

module ApplicationHelper
  def article_illustration(attachment, article_type = "default")
    folder = article_type === "static" ? "pages" : "diskusia"

    encode "#{server}/data/#{folder}/s/#{attachment.file}"
  end

  def user_portrait(attachment)
    if attachment.file.empty?
      "#{server}/data/users/default.png"
    else
      encode "#{server}/data/users/s/#{attachment.file}"
    end
  end

  def body_logo(attachment)
    "#{server}/data/static/s/#{attachment.file}"
  end

  private
    def encode(uri)
      URI.encode(uri, ",")
    end

    def server
      ENV["DEMAGOG_IMAGE_SERVICE_URL"]
    end
end
