# coding: utf-8
require 'rails_helper'

feature 'Proposals' do

  background do
    Setting['feature.map'] = nil
  end

  after do
    Setting['feature.map'] = nil
  end

  scenario 'JS injection is prevented but safe html is respected' do
    author = create(:user)
    login_as(author)

    visit new_proposal_path
    fill_in 'proposal_title', with: 'Testing an attack'
    fill_in 'proposal_question', with: '¿Would you like to give assistance to war refugees?'
    fill_in 'proposal_summary', with: 'In summary, what we want is...'
    fill_in 'proposal_description', with: '<p>This is <script>alert("an attack");</script></p>'
    fill_in 'proposal_external_url', with: 'http://rescue.org/refugees'
    fill_in 'proposal_responsible_name', with: 'Isabel Garcia'
    check 'proposal_terms_of_service'

    click_button 'Create proposal'
    expect(page).to have_content 'Proposal created successfully.'

    click_link 'Not now, go to my proposal'

    expect(page).to have_content 'Testing an attack'
    expect(page.html).to include '<p>This is alert("an attack");</p>'
    expect(page.html).not_to include '<script>alert("an attack");</script>'
    expect(page.html).not_to include '&lt;p&gt;This is'
  end

  context("Search") do
    context "Advanced search" do
      context "Search by date" do
        scenario "Search by multiple filters", :js do
          ana  = create :user, official_level: 1
          john = create :user, official_level: 1

          proposal1 = create(:proposal, title: "Get Schwifty",   author: ana,  created_at: 1.minute.ago)
          proposal2 = create(:proposal, title: "Hello Schwifty", author: john, created_at: 2.days.ago)
          proposal3 = create(:proposal, title: "Save the forest")

          visit proposals_path

          click_link "Advanced search"
          fill_in "Write the text", with: "Schwifty"
          # select Setting['official_level_1_name'], from: "advanced_search_official_level"
          select "Last 24 hours", from: "js-advanced-search-date-min"

          click_button "Filter"

          expect(page).to have_content("There is 1 citizen proposal")

          within("#proposals") do
            expect(page).to have_content(proposal1.title)
          end
        end

        scenario "Maintain advanced search criteria", :js do
          visit proposals_path
          click_link "Advanced search"

          fill_in "Write the text", with: "Schwifty"
          # select Setting['official_level_1_name'], from: "advanced_search_official_level"
          select "Last 24 hours", from: "js-advanced-search-date-min"

          click_button "Filter"

          expect(page).to have_content("citizen proposals cannot be found")

          within "#js-advanced-search" do
            expect(page).to have_selector("input[name='search'][value='Schwifty']")
            # expect(page).to have_select('advanced_search[official_level]', selected: Setting['official_level_1_name'])
            expect(page).to have_select('advanced_search[date_min]', selected: 'Last 24 hours')
          end
        end
      end
    end
  end


  # custom tests CDJ Aude -----------------------

  context 'with with cdj_aude feature' do

    before do
      Setting['feature.cdj_aude'] = true
    end

    after do
      Setting['feature.cdj_aude'] = nil
    end

    scenario 'Create ' do
      author = create(:user)
      login_as(author)

      visit new_proposal_path
      expect(page).not_to have_current_path(new_proposal_path)
      expect(page).to have_current_path(root_path)
      expect(page).to have_content "You do not have permission to carry out the action"
    end
  end

  scenario 'Create with verified user without document_number' do
    author = create(:user, :verified)
    login_as(author)

    visit new_proposal_path
    expect(page).to have_selector('#proposal_responsible_name')

    fill_in 'proposal_title', with: 'Help refugees'
    fill_in 'proposal_question', with: '¿Would you like to give assistance to war refugees?'
    fill_in 'proposal_summary', with: 'In summary, what we want is...'
    fill_in 'proposal_description', with: 'This is very important because...'
    fill_in 'proposal_external_url', with: 'http://rescue.org/refugees'
    check 'proposal_terms_of_service'

    click_button 'Create proposal'
    expect(page).to have_content 'Proposal created successfully.'

    click_link 'Not now, go to my proposal'

    expect(Proposal.last.responsible_name).to eq(author.name)
  end

end
