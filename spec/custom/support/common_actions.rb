Dir["./spec/support/common_actions/*.rb"].each { |f| require f }

module CommonActions
  include Budgets
  include Comments
  include Debates
  include Emails
  include Notifications
  include Polls
  include Proposals
  include Tags
  include Users
  include Verifications
  include Votes

  def fill_in_signup_form(email = 'manuela@consul.dev', password = 'judgementday')
    fill_in 'user_username',              with: "Manuela Carmena #{rand(99999)}"
    fill_in 'user_email',                 with: email
    select_date "31-December-#{valid_date_of_birth_year}", from: 'user_date_of_birth'
    fill_in 'user_lastname', with: 'Carmena'
    fill_in 'user_firstname', with: 'Manuela'
    fill_in 'user_postal_code', with: '11000'
    fill_in 'user_password',              with: password
    fill_in 'user_password_confirmation', with: password
    check 'user_terms_of_service'
  end

end