class ElectionsController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_user?, only: [:dashboard]

  def results
    # [{user: <User:248264>, votes: 3, comments: []}]
    @election = Election.last_month
    @winners  = @election.winners
    @winners.map! do |winner|
      comments = @election.votes.where(selection_id: winner[:user].id).pluck(:comment)
      { user: winner[:user], vote_count: winner[:vote_count], comments: comments }
    end 
    # [{user: <Class: User>, vote_count: 3, comments: ["comment"]}]
  end

  def dashboard
    @elections = Election.joins("LEFT OUTER JOIN votes ON votes.election_id = elections.id").where.not(votes: {election_id: nil}).uniq.pluck(:month, :year, :id)
    @elections_collection = @elections.map { |e| ["#{e[0]} - #{e[1]}", e[2]] }
    # need list of month/years where votes exist
    # @elections = # maybe something like [{month: 1, year: 2015}, {month: 12, year: 2014}] 
  end

  # returns JSON about single election for dashboard
  def election
    election = Election.find(params[:election_id])
    votes    = election.votes.order(:selection_id)
    render json: { msg: "hello dar", election: election, votes: votes } 
  end
end
