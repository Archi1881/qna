module Voted
  extend ActiveSupport::Concern

  included do
    before_action :find_voteable, only: %i[positive negative revote]
  end

  def positive
    unless current_user&.author?(@voteable)
      @voteable.positive(current_user)

      render_json(flash.now[:notice] = 'Voted positive')
    end
  end

  def negative
    unless current_user&.author?(@voteable)
      @voteable.negative(current_user)

      render_json(flash.now[:notice] = 'Voted negative')
    end
  end

  def revote
    @voteable.votes.find_by(user_id: current_user)&.destroy

    render_json
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def find_voteable
    @voteable = model_klass.find(params[:id])
  end

  def render_json(*flash)
    render json: {
                   score: @voteable.rating,
                   klass: @voteable.class.to_s,
                   id: @voteable.id,
                   flash: flash
                 }
  end
end