class Vote < ActiveRecord::Base
	belongs_to :voter, class_name: "User"
  belongs_to :selection, class_name: "User"

  validates_presence_of :selection #, :voter

  # make scopes for:
    # scope :for_user, -> (user) { where(voter_id: user.id) }
    # scope :by_user, -> (user) { where(selection_id: user.id) }

  # make methods for:
    # winner_of(month, year)
    # last_winner
    # current_leader
end
