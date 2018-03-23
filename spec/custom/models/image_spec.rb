require 'rails_helper'

describe Image do
  # TODO i18n : broken because of test locale change
  xit_behaves_like "image validations", "budget_investment_image"
  xit_behaves_like "image validations", "proposal_image"

end
