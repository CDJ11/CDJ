require 'rails_helper'
require 'cancan/matchers'

describe Abilities::Animator do
  subject(:ability) { Ability.new(user) }

  let(:user) { animator.user }
  let(:animator) { create(:animator) }

  let(:other_user) { create(:user) }
  let(:hidden_user) { create(:user, :hidden) }

  let(:debate) { create(:debate) }
  let(:comment) { create(:comment) }
  let(:proposal) { create(:proposal) }
  let(:poll_question) { create(:poll_question) }

  let(:own_debate) { create(:debate, author: user) }
  let(:own_comment) { create(:comment, author: user) }
  let(:own_proposal) { create(:proposal, author: user) }

  let(:hidden_debate) { create(:debate, :hidden) }
  let(:hidden_comment) { create(:comment, :hidden) }
  let(:hidden_proposal) { create(:proposal, :hidden) }

  describe "admin abilities" do
    it { should be_able_to(:index, Debate) }
    it { should be_able_to(:show, debate) }
    it { should be_able_to(:vote, debate) }

    it { should be_able_to(:index, Proposal) }
    it { should be_able_to(:show, proposal) }
    
  end

  
  describe "hiding, reviewing and restoring" do
    let(:ignored_comment)  { create(:comment, :with_ignored_flag) }
    let(:ignored_debate)   { create(:debate,  :with_ignored_flag) }
    let(:ignored_proposal) { create(:proposal, :with_ignored_flag) }

    it { should be_able_to(:hide, comment) }
    it { should be_able_to(:hide_in_moderation_screen, comment) }
    it { should_not be_able_to(:hide, hidden_comment) }
    it { should_not be_able_to(:hide, own_comment) }

    it { should be_able_to(:moderate, comment) }
    it { should_not be_able_to(:moderate, own_comment) }

    it { should be_able_to(:hide, debate) }
    it { should be_able_to(:hide_in_moderation_screen, debate) }
    it { should_not be_able_to(:hide, hidden_debate) }
    it { should_not be_able_to(:hide, own_debate) }

    it { should be_able_to(:hide, proposal) }
    it { should be_able_to(:hide_in_moderation_screen, proposal) }
    it { should_not be_able_to(:hide, hidden_proposal) }
    it { should_not be_able_to(:hide, own_proposal) }

    it { should be_able_to(:ignore_flag, comment) }
    it { should_not be_able_to(:ignore_flag, hidden_comment) }
    it { should_not be_able_to(:ignore_flag, ignored_comment) }
    it { should_not be_able_to(:ignore_flag, own_comment) }

    it { should be_able_to(:ignore_flag, debate) }
    it { should_not be_able_to(:ignore_flag, hidden_debate) }
    it { should_not be_able_to(:ignore_flag, ignored_debate) }
    it { should_not be_able_to(:ignore_flag, own_debate) }

    it { should be_able_to(:moderate, debate) }
    it { should_not be_able_to(:moderate, own_debate) }

    it { should be_able_to(:ignore_flag, proposal) }
    it { should_not be_able_to(:ignore_flag, hidden_proposal) }
    it { should_not be_able_to(:ignore_flag, ignored_proposal) }
    it { should_not be_able_to(:ignore_flag, own_proposal) }

    it { should be_able_to(:moderate, proposal) }
    it { should_not be_able_to(:moderate, own_proposal) }

    it { should_not be_able_to(:hide, user) }
    it { should be_able_to(:hide, other_user) }

    it { should_not be_able_to(:block, user) }
    it { should be_able_to(:block, other_user) }

    it { should_not be_able_to(:restore, comment) }
    it { should_not be_able_to(:restore, debate) }
    it { should_not be_able_to(:restore, proposal) }
    it { should_not be_able_to(:restore, other_user) }

    # it { should be_able_to(:comment_as_moderator, debate) }
    # it { should be_able_to(:comment_as_moderator, proposal) }
    # it { should be_able_to(:comment_as_moderator, legislation_question) }
    it { should_not be_able_to(:comment_as_administrator, debate) }
    it { should_not be_able_to(:comment_as_administrator, proposal) }
  end
end