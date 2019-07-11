require_dependency Rails.root.join('app', 'helpers', 'users_helper').to_s

module Custom::UsersHelper

  def current_animator?
    current_user && current_user.animator?
  end

  def show_admin_menu?(user = nil)
    current_administrator? || current_animator? || current_moderator? || current_valuator? || current_manager?  || (user && user.administrator?)
  end

end