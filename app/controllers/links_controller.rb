class LinksController < ApplicationController
  before_action :authenticate_user!, only: %i[destroy]

  def destroy
    @link = Link.find(params[:id])

    if current_user.author?(@link.linkable)
      @link.destroy

      flash.now[:notice] = 'Link successfully deleted'
    end
  end
end
