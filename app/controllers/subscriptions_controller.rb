class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  def create
    @question = Question.find(params[:question_id])

    unless current_user.subscribed_of?(@question)
      @subscription = current_user.subscribe!(@question)

      flash[:notice] = 'Subscribed successfully'
    else
      flash[:notice] = 'Already subscribed'
    end
  end

  def destroy
    @subscription = Subscription.find(params[:id])

    if current_user.subscribed_of?(@subscription.question)
      @subscription.destroy

      flash[:notice] = 'Unsubscribed successfully'
    end
  end
end