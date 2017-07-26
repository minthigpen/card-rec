Rails.application.routes.draw do
  resources :surveys do
    collection do
      post :specific
    end
  end
  resources :color_profiles
  resources :images, controller: 'images', img_type: 'Image'
  resources :cards, controller: 'images', img_type: 'Card'
  resources :backgrounds, controller: 'images', img_type: 'Background'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # resources :images, only: [:index]
  # root to: "images#index"
  # resources :colors, only: [:index]
  # root to: "colors#index"

end
