class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show update destroy]
  
  after_action :publish_question, only: %i[create]

  authorize_resource

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @comment = Comment.new
    @answer.links.build
  end

  def new
    @question = Question.new
    @question.links.build
    @question.build_badge
  end

  def edit; end

  def create
    @question = Question.new(question_params)
    @question.user = current_user

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    @comment = Comment.new

    if current_user.author?(@question)
      @question.update(question_params)
      flash.now[:notice] = 'Question successfully edited'
    end
  end

  def destroy
    if current_user.author?(@question)
      @question.destroy
      redirect_to questions_path, notice: 'Question successfully deleted'
    else
      render :show
    end
  end

  private

  def load_question
    @question = Question.with_attached_files.find(params[:id])
    gon.question_id = @question.id
  end

  def question_params
    params.require(:question).permit(:title, :body, file: [],
                                                    links_attributes: %i[id name url _destroy],
                                                    badge_attributes: %i[name image])
  end

  def publish_question
    return if @question.errors.present?

    ActionCable.server.broadcast(
      'question_channel',
      ApplicationController.render(
        partial: 'questions/question',
        locals: { question: @question }
      )
    )
  end
end
