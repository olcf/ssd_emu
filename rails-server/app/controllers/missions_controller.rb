class MissionsController < ApplicationController
  before_action :set_mission, only: %i[ show update destroy check_completion ]

  # GET /missions
  def index
    @missions = Mission.all

    render json: @missions
  end

  # GET /missions/1
  def show
    render json: @mission
  end

  # GET /mission_with_chapters/1
  def mission_with_chapters
    missionId = params[:id]
    userId = request.headers['HTTP_USER_ID'] || params[:user_id]

    
    missions = Mission.find(missionId)
    
    # Get user chapter completion status for all chapters in this mission
    chapters_with_completion = missions.chapters.map do |chapter|
      userChapter = UserChapter.find_by(user_id: userId, chapter_id: chapter.id)
      is_completed = userChapter&.completed || false
      
      chapter.as_json(except: [:content]).merge(is_completed: is_completed)
    end
    
    render json: missions.as_json(except: [:chapters]).merge(chapters: chapters_with_completion)
  end

  # POST /missions
  def create
    @mission = Mission.new(mission_params)

    if @mission.save
      render json: @mission, status: :created, location: @mission
    else
      render json: @mission.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /missions/1
  def update
    if @mission.update(mission_params)
      render json: @mission
    else
      render json: @mission.errors, status: :unprocessable_entity
    end
  end

  # DELETE /missions/1
  def destroy
    @mission.destroy
  end



  # POST /missions/:id/check_completion
  def check_completion
    userId = request.headers['user_id']
    
    if userId.blank?
      render json: { error: 'User ID is required' }, status: :bad_request
      return
    end
    
    # Check if all chapters are completed
    all_chapters_completed = @mission.chapters.all? do |chapter|
      userChapter = UserChapter.find_by(user_id: userId, chapter_id: chapter.id)
      userChapter&.completed || false
    end
    
    if all_chapters_completed
      # Mark mission as completed
      userMission = UserMission.find_or_create_by(
        user_id: userId,
        mission_id: @mission.id
      )
      
      userMission.completed = true
      userMission.completed_at = Time.current
      userMission.save
      
      render json: { 
        success: true, 
        message: 'Mission completed!',
        mission_id: @mission.id,
        completed_at: userMission.completed_at
      }
    else
      render json: { 
        success: false, 
        message: 'Mission not yet completed',
        completed_chapters: @mission.chapters.count { |chapter|
          userChapter = UserChapter.find_by(user_id: userId, chapter_id: chapter.id)
          userChapter&.completed || false
        },
        total_chapters: @mission.chapters.count
      }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mission
      @mission = Mission.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def mission_params
      params.fetch(:mission, {})
    end
end
