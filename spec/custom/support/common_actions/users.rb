module Users

  def sign_up(email = 'manuela@consul.dev', password = 'judgementday')
    visit '/'

    click_link('Register', match: :first)

    fill_in 'user_email',                 with: email
    fill_in 'user_username',              with: "Manuela Carmena #{rand(99999)}"
    fill_in 'user_firstname',             with: "Manuela  #{rand(99999)}"
    fill_in 'user_lastname',              with: "Carmena  #{rand(99999)}"
    select_date "31-December-#{valid_date_of_birth_year}", from: 'user_date_of_birth'
    fill_in 'user_postal_code',           with: "11000"
    fill_in 'user_password',              with: password
    fill_in 'user_password_confirmation', with: password
    check 'user_terms_of_service'

    click_button 'register-btn'
  end

  def login_through_form_with_email_and_password(email='manuela@consul.dev', password='judgementday')
    Setting['feature.articles'] = true
    visit root_path
    click_link('Sign in', match: :first)

    fill_in 'user_login', with: email
    fill_in 'user_password', with: password

    click_button 'Enter'
    Setting['feature.articles'] = false
  end

  def login_through_form_as(user)
    visit root_path
    click_link("Sign in", match: :first)

    fill_in 'user_login', with: user.email
    fill_in 'user_password', with: user.password

    click_button 'Enter'
  end

  def reset_password
    create(:user, email: 'manuela@consul.dev')

    visit '/'
    click_link('Sign in', match: :first)
    click_link 'Forgotten your password?'

    fill_in 'user_email', with: 'manuela@consul.dev'
    click_button 'Send instructions'
  end

end
