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
    @elections_collection = @elections.map { |e| ["#{Date::MONTHNAMES[e[0]]} - #{e[1]}", e[2]] }
  end

  # returns JSON about single election for dashboard
  def election
    election = Election.find(params[:election_id])
    votes = election.votes.joins(:voter).joins(:selection).order(:selection_id).
      to_json(methods: :comment, include: {
        voter: {methods: :full_name},
        selection: {methods: :full_name}
      })
    render json: { msg: "hello dar", election: election, votes: votes }
    # votes => [{"id"=>15, "voter_id"=>4, "selection_id"=>3, "comment"=>"who else could even deal with it?", "created_at"=>"2015-02-21T19:23:19.971Z", "updated_at"=>"2015-03-21T18:23:19.972Z", "election_id"=>nil, "voter"=>{"first_name"=>"caleb", "last_name"=>"sanchez"}, "selection"=>{"first_name"=>"Jacob", "last_name"=>"Barrieault"}}]
  end
end
