class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
	
  has_many :votes, class_name: "Vote", foreign_key: "voter_id"
	has_many :selections, class_name: "Vote", foreign_key: "selection_id"
	
	validates_presence_of :first_name, :last_name
  validates_uniqueness_of :first_name, :last_name

	def full_name
		self.first_name + " " + self.last_name
	end

  def can_vote?
    vote = Vote.where(voter_id: self.id).take
    if vote && vote.created_at.month == Time.now.month && vote.created_at.year == Time.now.year
      return false
    else
      return true
    end
    # once we're using Postgres:
    # Entry.where('voter_id = ? AND extract(month from created_at) = ? AND extract(year from created_at) = ?', self.id, Time.now.month, Time.now.year).blank?
  end

end
