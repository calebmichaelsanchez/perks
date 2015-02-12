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
    # [{:month=>"February", :year=>2015, :winner=>[3, 4], :votes=>1}, {:month=>"February", :year=>2015, :winner=>[3, 4], :votes=>1}]
    @winners = Vote.winners
  end
end
