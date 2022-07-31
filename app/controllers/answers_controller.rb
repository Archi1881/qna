class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]
  before_action :load_question, only: %i[new create]\
  before_action :find_answer, only: %i[destroy]

  def create
    @answer = @question.answers.build(answer_params.merge(question: @question))
    @answer.user = current_user

    if @answer.save
      redirect_to @question, notice: 'Answer successfully added'
    else
      render 'questions/show'
    end
  end

  def destroy
    if current_user.author?(@answer)
      @answer.destroy
      redirect_to question_path(@answer.question), notice: 'Answer successfully deleted'
    else
      render 'questions/show'
    end
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end