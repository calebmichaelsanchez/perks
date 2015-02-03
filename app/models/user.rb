class User < ActiveRecord::Base
	has_many :votes
	def full_name
		self.first_name
	end
end
