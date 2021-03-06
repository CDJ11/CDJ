require 'rails_helper'

feature 'Votes' do

  background do
    @manuela = create(:user, verified_at: Time.current)
    @pablo = create(:user)
  end

  feature 'Debates' do
    background { login_as(@manuela) }

    feature 'Single debate' do

      scenario 'Trying to vote multiple times', :js do
        visit debate_path(create(:debate))

        find('.in-favor a').click
        expect(page).to have_content "1 vote"
        find('.in-favor a').click
        expect(page).not_to have_content "2 votes"

        within('.in-favor') do
          expect(page).to have_content "0%"
        end

        within('.against') do
          expect(page).to have_content "0%"
        end
      end

      scenario 'Toggle vote', :js do
        debate = create(:debate)
        create(:vote, voter: @manuela, votable: debate, vote_flag: true)
        visit debate_path(debate)

        expect(page).to have_content "1 vote"

        find('.in-favor a').click
        within('.in-favor') do
          expect(page).to have_content "0%"
        end
        expect(page).to have_content "No votes"

        find('.in-favor a').click
        within('.in-favor') do
          expect(page).to have_content "100%"
          expect(page).to have_css("a.voted")
        end

        expect(page).to have_content "1 vote"
      end

    end
  end



end
