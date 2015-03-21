class Vote < ActiveRecord::Base
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

  def self.tie?(month, year)
    # what to do if same num of votes?

  end

  def self.winners
    elections = Vote.all.pluck(:created_at).uniq.map{|t| {month: t.month, year: t.year} }
    winners = []
    elections.each do |election|
      month, year = election[:month], election[:year]
      if results = results_of(month, year)
        votes  = results[0][:votes]
        result = results.map{|r| r[:user_id] }
        winners << {month: Date::MONTHNAMES[month], year: year, winner: result, votes: votes }
      end
    end
    winners #[{year: 2015, month: "jan", winner: "donivan"}{month: ...}]
    # need to account for ties. ie { winner: "TIE: jack & jill"}
  end

  def self.current_leader
    month, year = Date.today.month, Date.today.year
    id = self.in_month(month, year).group(:selection_id).count.try(:max)
    id ? User.find(id[0]) : nil
  end

  def self.last_winners
    month, year = (Date.today - 1.month).month, Date.today.year
    self.results_of(month, year)
  end

end
