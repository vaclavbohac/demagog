# frozen_string_literal: true

Rails.application.routes.draw do
  get "article/:id" => "article#index", as: "article"

  root to: "homepage#index"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
