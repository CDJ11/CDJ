# coding: utf-8
require 'rails_helper'

feature 'Proposals' do

  # custom tests CDJ Aude -----------------------

  scenario 'Create with verified user without document_number' do
    author = create(:user, :verified)
    login_as(author)

    visit new_proposal_path
    expect(page).not_to have_selector('#proposal_responsible_name')

    fill_in 'proposal_title', with: 'Help refugees'
    fill_in 'proposal_question', with: '¿Would you like to give assistance to war refugees?'
    fill_in 'proposal_summary', with: 'In summary, what we want is...'
    fill_in 'proposal_description', with: 'This is very important because...'
    fill_in 'proposal_external_url', with: 'http://rescue.org/refugees'
    check 'proposal_skip_map'
    check 'proposal_terms_of_service'

    click_button 'Create proposal'
    expect(page).to have_content 'Proposal created successfully.'

    click_link 'Not now, go to my proposal'

    expect(Proposal.last.responsible_name).to eq(author.name)
  end

end
