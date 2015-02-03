class VotesController < ApplicationController
	def create
		vote = Vote.new(selection: params[:user_id], comment: params[:comment])
		vote.save
		flash[:alert] = "You did it!"
		redirect_to root_url
	end
end
