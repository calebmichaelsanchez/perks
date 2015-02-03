class VotesController < ApplicationController

  def index
    @users = User.all
  end

	def create
		vote = Vote.new(selection: params[:selection_id], comment: params[:comment])
		vote.save
		flash[:alert] = "You did it!"
		redirect_to root_url
	end
end
