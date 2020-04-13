require_relative "../lib/api_constraints"

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    api_routes = Proc.new do
      post "address/eligibility_check", to: "address_eligibilities#eligible"
    end

    scope module: :v1, constraints: ApiConstraints.new(version: "1", default: true) do
      api_routes.call
    end
  end
end
