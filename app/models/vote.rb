class Vote < ActiveRecord::Base
  belongs_to  :election
	belongs_to :voter, class_name: "User"
  belongs_to :selection, class_name: "User"

  validates_presence_of :selection, :voter

  scope :for_user, -> (user) { where(selection_id: user.id) }
  scope :by_user,  -> (user) { where(voter_id: user.id) }

  def self.in_month(month, year)
    time = Time.new(year, month)
    where(created_at: time.beginning_of_month..time.end_of_month)
  end

  def self.results_of(month, year)
    max_votes = self.in_month(month, year).group(:selection_id).count.max[1]
    results   = self.in_month(month, year).group(:selection_id).count.select{|id, votes| votes == max_votes}
    results.map { |id, votes| {user_id: id, votes: votes} }
  end

  def self.current_leader
    month, year = Date.today.month, Date.today.year
    id = self.in_month(month, year).group(:selection_id).count.try(:max)
    id ? User.find(id[0]) : nil
  end

  def self.last_winners
    date = Date.today - 1.month
    self.results_of(date.month, date.year)
  end

end
