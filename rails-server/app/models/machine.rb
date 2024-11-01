class Machine < ApplicationRecord
  belongs_to :user
  has_many :jobs
  validates :name, presence: true, uniqueness: { scope: :user_id}
end
