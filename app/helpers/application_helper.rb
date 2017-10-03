# frozen_string_literal: true

module ApplicationHelper
  def speaker_portrait(attachment)
    "http://demagog.cz/data/politik/t/#{attachment.file}"
  end

  def article_illustration(attachment, article_type = "default")
    folder = article_type === "static" ? "pages" : "diskusia"

    "http://demagog.cz/data/#{folder}/s/#{attachment.file}"
  end
end
