# coding: utf-8
require 'rails_helper'

feature 'Debates' do

  context("Search") do
    context "Advanced search" do
      context "Search by date" do

        scenario "Search by multiple filters", :js do
          ana  = create :user, official_level: 1
          john = create :user, official_level: 1

          debate1 = create(:debate, title: "Get Schwifty",   author: ana,  created_at: 1.minute.ago)
          debate2 = create(:debate, title: "Hello Schwifty", author: john, created_at: 2.days.ago)
          debate3 = create(:debate, title: "Save the forest")

          visit debates_path

          click_link "Advanced search"
          fill_in "Write the text", with: "Schwifty"
          # select Setting['official_level_1_name'], from: "advanced_search_official_level"
          select "Last 24 hours", from: "js-advanced-search-date-min"

          click_button "Filter"

          within("#debates") do
            expect(page).to have_css('.debate', count: 1)
            expect(page).to have_content(debate1.title)
          end
        end

        scenario "Maintain advanced search criteria", :js do
          visit debates_path
          click_link "Advanced search"

          fill_in "Write the text", with: "Schwifty"
          # select Setting['official_level_1_name'], from: "advanced_search_official_level"
          select "Last 24 hours", from: "js-advanced-search-date-min"

          click_button "Filter"

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
