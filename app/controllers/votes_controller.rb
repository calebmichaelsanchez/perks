class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_user?, only: [:dashboard]

  def index
    @users = User.where.not(id: current_user.id)
  end

	def create
    if !current_user.can_vote?
      flash[:error] = "You have already voted this month."
    else
      election = Election.where(month: Date.today.month, year: Date.today.year).first_or_create
  		vote = Vote.new(election_id: election.id, voter_id: current_user.id, selection_id: params[:selection_id], comment: params[:comment])
      if election.persisted? && vote.save
    		flash[:alert] = "You did it!"
      else
        flash[:error] = "Something went horribly wrong. We couldn't count your vote!"
      end
    end
		redirect_to root_url
	end

  def results
    # [{user_id: 1, votes: 3, comments: []}]
    @winners = Election.last_winners
    @winners.map! do |winner|
      time = DateTime.now - 1.month
      comments = Vote.where(created_at: time.beginning_of_month..time.end_of_month, selection_id: winner[:user_id]).pluck(:comment)
      { user: User.find(winner[:user_id]), votes: winner[:votes], comments: comments }
    end 
    # [{user: <Class: User>, votes: 3, comments: ["comment"]}]
  end

  def dashboard
    # need list of month/years where votes exist
    # @elections = # maybe something like [{month: 1, year: 2015}, {month: 12, year: 2014}] 
  end

end
