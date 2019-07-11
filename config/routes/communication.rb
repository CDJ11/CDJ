namespace :communication do
  root to: "dashboard#index"

  # resources :articles, path: '/actualites', only: [:index, :new, :create, :edit, :update, :show, :destroy]

  resources :tags, only: [:index, :create, :update, :destroy]

  resources :newsletters do
    member do
      post :deliver
    end
    get :users, on: :collection
  end

  resources :admin_notifications do
    member do
      post :deliver
    end
  end

  resources :system_emails, only: [:index] do
    get :view
    get :preview_pending
    put :moderate_pending
    put :send_pending
  end

  resources :emails_download, only: :index do
    get :generate_csv, on: :collection
  end

  resources :banners, only: [:index, :new, :create, :edit, :update, :destroy] do
    collection { get :search }
  end
end
