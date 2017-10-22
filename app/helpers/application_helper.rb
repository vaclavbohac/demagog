# frozen_string_literal: true

module ApplicationHelper
  def speaker_portrait(attachment)
    "#{server}/data/politik/t/#{attachment.file}"
  end

  def article_illustration(attachment, article_type = "default")
    folder = article_type === "static" ? "pages" : "diskusia"

    "#{server}/data/#{folder}/s/#{attachment.file}"
  end

  private
    def server
      ENV["DEMAGOG_IMAGE_SERVICE_URL"]
    end
end
