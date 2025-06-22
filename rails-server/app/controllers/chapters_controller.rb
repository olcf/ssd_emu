class ChaptersController < ApplicationController
  before_action :set_chapter, only: %i[ show update destroy complete ]

  # GET /chapters
  def index
    @chapters = Chapter.all

    render json: @chapters
  end

  # GET /chapters/1
  def show
    userId = request.headers['user_id']
    
    # Get user chapter completion status
    userChapter = UserChapter.find_by(user_id: userId, chapter_id: @chapter.id)
    is_completed = userChapter&.completed || false
    
    render json: @chapter.as_json(include: {
      quizzes: {
        except: [:created_at, :updated_at]
      }
    }).merge(is_completed: is_completed)
  end

  # POST /chapters/:id/complete
  def complete
    # Try to get user_id from headers first, then from params
    userId = request.headers['user_id'] || params[:user_id]
    
    if userId.blank?
      render json: { error: 'User ID is required' }, status: :bad_request
      return
    end
    
    # Convert to integer if it's a string
    userId = userId.to_i if userId.is_a?(String) && userId.match?(/^\d+$/)
    
    # Find or create user chapter record
    userChapter = UserChapter.find_or_create_by(
      user_id: userId,
      chapter_id: @chapter.id
    )
    # Mark chapter as completed
    userChapter.completed = true
    userChapter.completed_at = Time.current
    
    if userChapter.save
      render json: { 
        success: true, 
        message: 'Chapter completed successfully!',
        chapter_id: @chapter.id,
        completed_at: userChapter.completed_at
      }
    else
      render json: { 
        success: false, 
        error: 'Failed to complete chapter',
        errors: userChapter.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  # POST /chapters
  def create
    @chapter = Chapter.new(chapter_params)

    if @chapter.save
      render json: @chapter, status: :created, location: @chapter
    else
      render json: @chapter.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /chapters/1
  def update
    if @chapter.update(chapter_params)
      render json: @chapter
    else
      render json: @chapter.errors, status: :unprocessable_entity
    end
  end

  # DELETE /chapters/1
  def destroy
    @chapter.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chapter
      @chapter = Chapter.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def chapter_params
      params.fetch(:chapter, {})
    end
end
