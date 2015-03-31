class Election < ActiveRecord::Base
  has_many :votes

  def winners
    max_votes = self.votes.group(:selection_id).count.max[1]
    winners   = self.votes.group(:selection_id).count.select{|id, vote_count| vote_count == max_votes}
    winners.map { |id, vote_count| {user: User.find(id), votes: vote_count} }
  end

  def tie?
    winners.size > 1
  end

  def self.last_election
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
