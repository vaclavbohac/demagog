# frozen_string_literal: true

Rails.application.routes.draw do
  concern :paginatable do
    get "(page/:page)", action: :index, on: :collection, as: ""
  end

  get "article/:id" => "article#index", as: "article"

  root to: "homepage#index", concerns: :paginatable

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
