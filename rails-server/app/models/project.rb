class Project < ApplicationRecord
  has_many :jobs

  validates :name, presence: true,  uniqueness: {case_sensitive: false}
end
