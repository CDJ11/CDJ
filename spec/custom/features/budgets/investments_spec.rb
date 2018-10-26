require 'rails_helper'
require 'sessions_helper'

feature 'Budget Investments' do

  let(:author)  { create(:user, :level_two, username: 'Isabel') }
  let(:budget)  { create(:budget, name: "Big Budget") }
  let(:other_budget) { create(:budget, name: "What a Budget!") }
  let(:group) { create(:budget_group, name: "Health", budget: budget) }
  let!(:heading) { create(:budget_heading, name: "More hospitals", price: 666666, group: group) }

  before do
    Setting['feature.allow_images'] = true
    Setting['feature.budgets'] = true
  end

  after do
    Setting['feature.allow_images'] = nil
    Setting['feature.budgets'] = nil
  end

  # TODO
  scenario "Show milestones", :js do
    user = create(:user)
    investment = create(:budget_investment)
    create(:budget_investment_milestone, investment: investment,
                                         description_en: "Last milestone with a link to https://consul.dev",
                                         description_es: "Último hito con el link https://consul.dev",
                                         publication_date: Date.tomorrow)
    first_milestone = create(:budget_investment_milestone, investment: investment,
                                                           description: "First milestone",
                                                           publication_date: Date.yesterday)
    image = create(:image, imageable: first_milestone)
    document = create(:document, documentable: first_milestone)

    login_as(user)
    visit budget_investment_path(budget_id: investment.budget.id, id: investment.id)

    find("#tab-milestones-label").click

    within("#tab-milestones") do
      expect(first_milestone.description).to appear_before('Last milestone with a link to https://consul.dev')
      expect(page).to have_content(Date.tomorrow)
      expect(page).to have_content(Date.yesterday)
      expect(page).not_to have_content(Date.current)
      expect(page.find("#image_#{first_milestone.id}")['alt']).to have_content(image.title)
      expect(page).to have_link(document.title)
      expect(page).to have_link("https://consul.dev")
    end

  end

  context("Search") do

    context "Advanced search" do
      context "Search by date" do
        scenario "Search by multiple filters", :js do
          ana  = create :user, official_level: 1
          john = create :user, official_level: 1

          bdgt_invest1 = create(:budget_investment, heading: heading,title: "Get Schwifty",   author: ana,  created_at: 1.minute.ago)
          bdgt_invest2 = create(:budget_investment, heading: heading,title: "Hello Schwifty", author: john, created_at: 2.days.ago)
          bdgt_invest3 = create(:budget_investment, heading: heading,title: "Save the forest")

          visit budget_investments_path(budget)

          click_link "Advanced search"
          fill_in "Write the text", with: "Schwifty"
          # select Setting['official_level_1_name'], from: "advanced_search_official_level"
          select "Last 24 hours", from: "js-advanced-search-date-min"

          click_button "Filter"

          expect(page).to have_content("There is 1 investment")

          within("#budget-investments") do
            expect(page).to have_content(bdgt_invest1.title)
          end
        end

        scenario "Maintain advanced search criteria", :js do
          visit budget_investments_path(budget)
          click_link "Advanced search"

          fill_in "Write the text", with: "Schwifty"
          # select Setting['official_level_1_name'], from: "advanced_search_official_level"
          select "Last 24 hours", from: "js-advanced-search-date-min"

          click_button "Filter"

          expect(page).to have_content("investments cannot be found")

          within "#js-advanced-search" do
            expect(page).to have_selector("input[name='search'][value='Schwifty']")
            # expect(page).to have_select('advanced_search[official_level]', selected: Setting['official_level_1_name'])
            expect(page).to have_select('advanced_search[date_min]', selected: 'Last 24 hours')
          end
        end
      end
    end

  end

end
