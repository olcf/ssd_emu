class Project < ApplicationRecord
  has_many :jobs

  validates: :name, uniqueness: {case_sensitive: false}
end
