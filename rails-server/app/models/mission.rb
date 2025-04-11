class Mission < ApplicationRecord
  has_many :chapters
  has_many :user_missions
end
