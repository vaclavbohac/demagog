# frozen_string_literal: true

require "elasticsearch/rails/tasks/import"

namespace :elasticsearch do
  desc "Reindex everything"
  task reindex: %w[elasticsearch:reindex_articles elasticsearch:reindex_speakers elasticsearch:reindex_statements]

  task :reindex_articles, [] => [:environment] do |task, args|
    Article.import force: true
  end

  task :reindex_speakers, [] => [:environment] do |task, args|
    Speaker.import force: true
  end

  task :reindex_statements, [] => [:environment] do |task, args|
    Statement.import force: true
  end
end
