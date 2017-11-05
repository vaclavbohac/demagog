# frozen_string_literal: true

Rails.application.routes.draw do
  get "speaker/index"

  concern :paginatable do
    get "(page/:page)", action: :index, on: :collection, as: ""
  end

  get "statement/:id" => "statement#show", as: "statement"
  get "article/:id" => "article#index", as: "article"
  get "speaker/:id" => "speaker#show", as: "speaker", concerns: :paginatable
  get "archive" => "archive#index", as: "archive", concerns: :paginatable

  root to: "homepage#index"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
