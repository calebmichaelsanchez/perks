class User < ActiveRecord::Base
	has_many :votes
	validates_presence_of :first_name, :last_name
	validate :name_is_unique
	def name_is_unique
		true
		#jacob will make this better
	end
	def full_name
		self.first_name + " " + self.last_name
	end
end
