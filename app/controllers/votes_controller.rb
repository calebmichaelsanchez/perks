class VotesController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.all
  end

	def create
		vote = Vote.new(voter_id: current_user.id, selection_id: params[:selection_id], comment: params[:comment])
		vote.save
		flash[:alert] = "You did it!"
		redirect_to root_url
	end
end
