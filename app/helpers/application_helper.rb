# frozen_string_literal: true

module ApplicationHelper
  def speaker_portrait(attachment)
    "http://demagog.cz/data/politik/t/#{attachment.file}"
  end

  def article_illustration(attachment)
    "http://demagog.cz/data/diskusia/s/#{attachment.file}"
  end
end
