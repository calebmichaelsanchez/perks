class VotesController < ApplicationController
  before_action :authenticate_user!

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

end
