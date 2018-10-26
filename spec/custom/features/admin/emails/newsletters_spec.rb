require 'rails_helper'

feature "Admin newsletter emails" do

  background do
    admin = create(:administrator)
    login_as(admin.user)
    create(:budget)
  end

  scenario "Update" do
    newsletter = create(:newsletter)

    visit admin_newsletters_path
    within("#newsletter_#{newsletter.id}") do
      click_link "Edit"
    end

    fill_in_newsletter_form(subject: "This is a subject",
                            segment_recipient: "Proposal authors",
                            body: "This is a body" )
    click_button "Update Newsletter"

    expect(page).to have_content "Newsletter updated successfully"
    expect(page).to have_content "This is a subject"
    expect(page).to have_content "Proposal authors"
    expect(page).to have_content "no-reply@consul.dev"
    expect(page).to have_content "This is a body"
  end

end
