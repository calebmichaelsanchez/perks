class ElectionsController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_user?, only: [:dashboard]

  def results
    # [{user_id: 1, votes: 3, comments: []}]
    @winners = Election.last_winners
    @winners.map! do |winner|
      time = DateTime.now - 1.month
      comments = Vote.where(created_at: time.beginning_of_month..time.end_of_month, selection_id: winner[:user_id]).pluck(:comment)
      { user: winner[:user], votes: winner[:votes], comments: comments }
    end 
    # [{user: <Class: User>, votes: 3, comments: ["comment"]}]
  end

  def dashboard
    # need list of month/years where votes exist
    # @elections = # maybe something like [{month: 1, year: 2015}, {month: 12, year: 2014}] 
  end
end
