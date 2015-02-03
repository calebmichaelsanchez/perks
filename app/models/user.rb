class User < ActiveRecord::Base
	has_many :votes, class_name: "Vote", foreign_key: "voter_id"
	has_many :selections, class_name: "Vote", foreign_key: "selection_id"
	
	validates_presence_of :first_name, :last_name

	def full_name
		self.first_name + " " + self.last_name
	end

end
