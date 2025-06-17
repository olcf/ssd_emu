class MissionsController < ApplicationController
  before_action :set_mission, only: %i[ show update destroy ]

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
    userId = request.headers['user_id']
    
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
