class User < ActiveRecord::Base
	def full_name
		self.first_name
	end
end
