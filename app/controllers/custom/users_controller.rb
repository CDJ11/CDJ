require_dependency Rails.root.join('app', 'controllers', 'users_controller').to_s

class UsersController < ApplicationController
  has_filters %w{proposals debates budget_investments comments articles follows}, only: :show

  private

    def set_activity_counts
      @activity_counts = HashWithIndifferentAccess.new(
                          proposals: Proposal.where(author_id: @user.id).count,
                          debates: (Setting['feature.debates'] ? Debate.where(author_id: @user.id).count : 0),
                          budget_investments: (Setting['feature.budgets'] ? Budget::Investment.where(author_id: @user.id).count : 0),
                          comments: only_active_commentables.count,
                          articles: (Setting['feature.articles'] ? Article.published.where(author_id: @user.id).count : 0),
                          follows: @user.follows.map(&:followable).compact.count)
    end

    def load_filtered_activity
      set_activity_counts
      case params[:filter]
      when "proposals" then load_proposals
      when "debates"   then load_debates
      when "budget_investments" then load_budget_investments
      when "comments" then load_comments
      when "follows" then load_follows
      when "articles" then load_articles
      else load_available_activity
      end
    end

    def load_available_activity
      if @activity_counts[:proposals] > 0
        load_proposals
        @current_filter = "proposals"
      elsif @activity_counts[:debates] > 0
        load_debates
        @current_filter = "debates"
      elsif  @activity_counts[:budget_investments] > 0
        load_budget_investments
        @current_filter = "budget_investments"
      elsif  @activity_counts[:comments] > 0
        load_comments
        @current_filter = "comments"
      elsif  @activity_counts[:articles] > 0
        load_articles
        @current_filter = "articles"
      elsif  @activity_counts[:follows] > 0
        load_follows
        @current_filter = "follows"
      end
    end

    def load_articles
      @articles = Article.published.where(author_id: @user.id).order(created_at: :desc).page(params[:page])
    end

end
