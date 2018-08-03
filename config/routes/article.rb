resources :articles, path: '/news', only: [:index, :show]

namespace :communication do
  resources :articles,
    path: '/actualites',
    only: [:index, :new, :create, :edit, :update, :show, :destroy]
end
