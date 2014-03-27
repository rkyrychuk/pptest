Pptest::Application.routes.draw do
  resources :posts do 
    collection do
      get :notify
    end
  end
  resources :payments, only: [:show, :create, :destroy] do
    collection do
      get :success
      get :cancel
    end
  end
end
