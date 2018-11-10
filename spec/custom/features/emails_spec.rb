require 'rails_helper'

feature 'Emails' do

  background do
    reset_mailer
  end

  scenario "Email depending on user's locale" do
    visit root_path(locale: :es)

    click_link('Registrarse', match: :first)
    fill_in_signup_form
    click_button 'Registrarse'

    email = open_last_email
    expect(email).to deliver_to('manuela@consul.dev')
    expect(email).to have_body_text(user_confirmation_path)
    expect(email).to have_subject('Instrucciones de confirmación')
  end

end
