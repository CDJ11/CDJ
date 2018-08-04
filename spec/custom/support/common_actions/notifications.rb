module Notifications
  def create_proposal_notification(proposal)
    login_as(proposal.author)
    visit root_path

    click_link("My activity", match: :first)

    within("#proposal_#{proposal.id}") do
      click_link "Send notification"
    end

    fill_in 'proposal_notification_title', with: "Thanks for supporting proposal: #{proposal.title}"
    fill_in 'proposal_notification_body', with: "Please share it with others! #{proposal.summary}"
    click_button "Send message"

    expect(page).to have_content "Your message has been sent correctly."
    Notification.last
  end

  def click_notifications_icon
    first("#notifications a").click
  end

end
