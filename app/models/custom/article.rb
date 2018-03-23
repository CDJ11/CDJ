class Article < ActiveRecord::Base
  VALID_STATUSES = %w(draft published)

  belongs_to :author, -> { with_hidden }, class_name: 'User', foreign_key: 'author_id'

  validates :title, presence: true
  validates :status, presence: true, inclusion: { in: VALID_STATUSES }

  scope :published, -> { where(status: 'published').order('id DESC') }

  def to_param
    "#{id}-#{title}".parameterize
  end

end
