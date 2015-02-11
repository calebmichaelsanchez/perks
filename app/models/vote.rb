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

  def self.winner_of(month, year)
    id = self.in_month(month, year).group(:selection_id).count.try(:max)
    id ? User.find(id[0]) : nil
  end

  def self.tie?(month, year)
    # what to do if same num of votes? 
  end

  def self.year_winners(year)
    winners = []
    1.upto(12) do |month|
      if winner = winner_of(month, year)
        winners << {month: Date::MONTHNAMES[month], winner: winner.full_name }
      end
    end
    winners #[{month: "jan", winner: "donivan"}{month: ...}]
    # need to account for ties. ie { winner: "TIE: jack & jill"}
  end

  def self.current_leader
    month, year = Date.today.month, Date.today.year
    id = self.in_month(month, year).group(:selection_id).count.try(:max)
    id ? User.find(id[0]) : nil
  end

  def self.last_winner
    month, year = (Date.today - 1.month).month, Date.today.year
    self.winner_of(month, year)
  end

end
