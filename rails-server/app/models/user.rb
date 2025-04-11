class User < ApplicationRecord
  has_many :jobs
  has_many :user_missions
  has_many :missions, through: :user_missions
  has_many :user_chapters
  has_many :chapters, through: :user_chapters

  validates :username, presence: true, uniqueness: {case_sensitive: false}
  validates :email, presence: true, uniqueness: { case_sensitive: false}
  
  after_create :create_mission_and_chapters_for_user
  private
  def create_mission_and_chapters_for_user
    missions = Mission.all
    missions.each do |mission|
      UserMission.create!(user: self, mission: mission, completed: false)
      mission.chapters.each do |chapter|
        UserChapter.create!(user: self, chapter: chapter, completed: false)
      end
    end
  end
end
