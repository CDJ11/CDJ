# Script permettant de gerer les liens et elements manquant apres l'import de la BDD originelle
require 'csv'
module PostDbImport

  def self.call!
    set_proposals_community!
    complete_imported_user_profiles
  end
  
  def self.complete_imported_user_profiles
    self.normalize_legacy_users_email
    self.complete_with_csv_info
    self.erase_unknown_users
  end

  private

  def self.normalize_legacy_users_email
    User.all.each do |user|
      normalized_email = user.email.try(:downcase).try(:strip)
      user.update_column(:email, normalized_email)
    end
  end

  def self.complete_with_csv_info
    ::CSV.foreach("doc/custom/CDJ_completion_utilisateurs.csv" ,{headers: :true}) do |row|
      user = User.where(email: row['Email']).first
      if user.present? && user.lastname.blank?
        p "update user #{row['Email']}"
        p "birthdate : #{row['Date de naissance (jj-mm-aaaa)'].to_date}"
        user.update_attributes(
          lastname: row['Nom'],
          firstname: row['Prénom'],
          date_of_birth: row['Date de naissance (jj-mm-aaaa)'].to_date,
          postal_code: row['Code postal'],
          city: row['Ville'],
        )
        p user.errors unless user.valid?
      end
    end
  end

  def self.erase_unknown_users
    User.where(firstname: nil).each do |user|
      user.erase(erase_reason = "supprimé lors de mise en prod v2 - 01/2019")
    end
  end

  def self.set_proposals_community!
    Proposal.where(community_id: nil).each do |proposal|
      proposal.associate_community
      proposal.save!
    end
  end

end
