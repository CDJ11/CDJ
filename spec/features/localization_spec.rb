require 'rails_helper'

feature 'Localization' do

  # CDJ custom : espagnol pas langue principale
  xscenario 'Wrong locale' do
    card = create(:widget_card, title: 'Bienvenido a CONSUL',
                                description: 'Software libre para la participación ciudadana.',
                                link_text: 'Más información',
                                link_url: 'http://consulproject.org/',
                                header: true)

    visit root_path(locale: :es)
    visit root_path(locale: :klingon)

    expect(page).to have_text('Bienvenido a CONSUL')
  end

  scenario 'Available locales appear in the locale switcher' do
    visit '/'

    within('.locale-form .js-location-changer') do
      expect(page).to have_content 'Español'
      expect(page).to have_content 'English'
    end
  end

  scenario 'The current locale is selected' do
    visit '/'
    expect(page).to have_select('locale-switcher', selected: 'English')
  end

  scenario 'Changing the locale', :js do
    visit '/'
    expect(page).to have_content('Language')

    select('Español', from: 'locale-switcher')
    expect(page).to have_content('Idioma')
    expect(page).not_to have_content('Language')
    expect(page).to have_select('locale-switcher', selected: 'Español')
  end

  scenario 'Locale switcher not present if only one locale' do
    allow(I18n).to receive(:available_locales).and_return([:en])

    visit '/'
    expect(page).not_to have_content('Language')
    expect(page).not_to have_css('div.locale')
  end

  context "Missing language names" do

    let!(:default_enforce) { I18n.enforce_available_locales }
    let!(:default_locales) { I18n.available_locales.dup }

    before do
      I18n.enforce_available_locales = false
      I18n.available_locales = default_locales + [:wl]
      I18n.locale = :wl
    end

    after do
      I18n.enforce_available_locales = default_enforce
      I18n.available_locales = default_locales
      I18n.locale = I18n.default_locale
    end

    scenario 'Available locales without language translation display locale key' do
      visit '/'

      within('.locale-form .js-location-changer') do
        expect(page).to have_content 'wl'
      end
    end

  end
end
