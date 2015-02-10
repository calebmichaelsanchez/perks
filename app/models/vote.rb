class Vote < ActiveRecord::Base
	belongs_to :voter, class_name: "User"
  belongs_to :selection, class_name: "User"

  validates_presence_of :selection, :voter

  scope :for_user, -> (user) { where(selection_id: user.id) }
  scope :by_user,  -> (user) { where(voter_id: user.id) }
  
  def self.in_month(month, year)
    date = Date.new(year, month)
    last_month, next_month = date - 1.month, date + 1.month 
    where("created_at >= ? AND created_at <= ?", last_month, next_month)
  end

  def self.winner_of(month, year)
    id = self.in_month(month, year).group(:selection_id).count.try(:max)
    id ? User.find(id[0]) : nil
  end

  def self.current_leader
    month, year = Date.today.month, Date.today.year
    id = self.in_month(month, year).group(:selection_id).count.try(:max)
    id ? User.find(id[0]) : nil
  end

  def self.last_winner
    month, year = (Date.today - 1.month).month, Date.today.year
    byebug
    self.winner_of(month, year)
  end

  def self.elections
    #return array: [month/year => winner]
  end

end
