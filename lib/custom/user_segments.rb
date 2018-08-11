require_dependency Rails.root.join('lib', 'user_segments').to_s

class UserSegments
  SEGMENTS = %w(all_users
                animators
                administrators
                proposal_authors
                )

  def self.animators
    all_users.animators
  end


  private

end
