require 'rails_helper'

RSpec.describe Poll::Question, type: :model do
  let(:poll_question) { build(:poll_question) }


  describe "#copy_attributes_from_proposal" do
    before { create_list(:geozone, 3) }
    let(:proposal) { create(:proposal) }

    context "locale with non-underscored name" do
      before do
        I18n.locale = :"en"
        Globalize.locale = I18n.locale
      end

      it "correctly creates a translation" do
        poll_question.copy_attributes_from_proposal(proposal)
        translation = poll_question.translations.first

        expect(poll_question.title).to eq(proposal.title)
        expect(translation.title).to eq(proposal.title)
        expect(translation.locale).to eq(:"en")
      end
    end
  end

end
