class UserMission < ApplicationRecord
  belongs_to :user
  belongs_to :mission
end
