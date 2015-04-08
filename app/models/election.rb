class Election < ActiveRecord::Base
  has_many :votes

  validates_presence_of  :month, :year
  validates_uniqueness_of :month, scope: :year

  def winners
    max_votes = self.votes.group(:selection_id).count.max[1]
    winners   = self.votes.group(:selection_id).count.select{|id, vote_count| vote_count == max_votes}
    winners.map { |id, vote_count| {user: User.find(id), vote_count: vote_count} }
  end

  def tie?
    winners.size > 1
  end

  def self.last_election
    date = Date.today - 1.month
    where(month: date.month, year: date.year).take
  end

  def current_leaders
    winners
  end

  def self.current_leaders
    where(month: Date.today.month, year: Date.today.year).take.try(:current_leaders)
  end

  def self.last_month
    date = Date.today - 1.month
    where(month: date.month, year: date.year).take
  end

  def self.last_winners
    last_election.try(:winners) || []
  end

  def self.winners_of(month, year)
    where(month: month, year: year).take.try(:winners) || []
  end

end
