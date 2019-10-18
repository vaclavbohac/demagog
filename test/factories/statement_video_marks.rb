# frozen_string_literal: true

FactoryBot.define do
  factory :statement_video_mark do
    start { 10 }
    stop { 50 }
    source
    statement
  end
end
