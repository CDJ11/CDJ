module Verifications

  def verify_residence
    select 'DNI', from: 'residence_document_type'
    fill_in 'residence_document_number', with: "12345678Z"
    select_date "31-December-#{valid_date_of_birth_year}", from: 'residence_date_of_birth'
    fill_in 'residence_postal_code', with: '28013'
    check 'residence_terms_of_service'

    click_button 'Verify residence'
    expect(page).to have_content 'Residence verified'
  end

  def officing_verify_residence
    select 'DNI', from: 'residence_document_type'
    fill_in 'residence_document_number', with: "12345678Z"
    fill_in 'residence_year_of_birth', with: "#{valid_date_of_birth_year}"

    click_button 'Validate document'

    expect(page).to have_content 'Document verified with Census'
  end

end
