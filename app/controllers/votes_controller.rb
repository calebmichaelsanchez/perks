class VotesController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.where.not(id: current_user.id)
  end

	def create
		vote = Vote.new(voter_id: current_user.id, selection_id: params[:selection_id], comment: params[:comment])
		vote.save
		flash[:alert] = "You did it!"
		redirect_to root_url
	end

  def results
    @months = Vote.elections
  end
end
