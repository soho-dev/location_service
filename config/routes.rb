Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    post "address/eligibility_check", to: "address_eligibilities#eligible"
  end
end
