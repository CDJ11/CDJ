require_dependency Rails.root.join('app', 'controllers', 'users_controller').to_s

class UsersController < ApplicationController
  has_filters %w{proposals debates budget_investments comments articles follows}, only: :show

end
