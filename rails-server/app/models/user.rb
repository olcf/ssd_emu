class User < ApplicationRecord
  has_many :jobs
  validates :username, presence: true, uniqueness: {case_sensitive: false}
  validates :email, presence: true, uniqueness: { case_sensitive: false}
end
