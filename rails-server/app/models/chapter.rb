class Chapter < ApplicationRecord
  belongs_to :mission
  has_many :quizzes
  has_many :user_chapters
end
