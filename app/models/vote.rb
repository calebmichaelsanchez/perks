class Vote < ActiveRecord::Base
  belongs_to :election
	belongs_to :voter, class_name: "User"
  belongs_to :selection, class_name: "User"

  validates_presence_of :selection, :voter

  scope :for_user, -> (user) { where(selection_id: user.id) }
  scope :by_user,  -> (user) { where(voter_id: user.id) }

end
