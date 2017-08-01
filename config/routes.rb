Rails.application.routes.draw do
  root controller: 'surveys', action: 'new'

  resources :surveys do
    collection do
      post :specific
    end
  end
  resources :color_profiles
  resources :images, controller: 'images', img_type: 'Image'
  resources :cards, controller: 'images', img_type: 'Card'

  get 'recommended_backgrounds/:new_paper_id', to: 'cards#recommended_backgrounds'

  resources :backgrounds, controller: 'images', img_type: 'Background'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
