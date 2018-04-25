require_dependency Rails.root.join('app', 'models', 'user').to_s


class User < ActiveRecord::Base

  GENDERS = %w(male female).freeze

  validates :firstname,
            :lastname,
            :date_of_birth,
            :postal_code,
            presence: true

  private def set_default_username
    self.username = [lastname, firstname].join(" ")
  end
  before_validation :set_default_username, if: -> { username.blank? }


end
