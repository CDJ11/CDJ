require 'rails_helper'

describe Document do
  # TODO i18n : broken because of test locale change
  xit_behaves_like "document validations", "budget_investment_document"
  xit_behaves_like "document validations", "proposal_document"

end
