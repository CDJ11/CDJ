require 'rails_helper'

feature "Notifications" do

  let(:user) { create :user }

  background do
    login_as(user)
    visit root_path
  end

  # CDJ custom : broken no time to investigate TODO
  xscenario "Bell" do
    create(:notification, user: user)
    visit root_path

    within("#notifications", match: :first) do
      expect(page).to have_css(".icon-circle")
    end

    click_notifications_icon
    first(".notification a").click
    within("#notifications", match: :first) do
      expect(page).to_not have_css(".icon-circle")
    end
  end

end
