class SearchController < ApplicationController
  skip_before_action :authenticate_user!
  authorize_resource

  def index
    if params[:query].present?
      @results = Search.filter(params[:query], resource: params[:resource])
    else
      @results = []
    end
    respond_with @results
  end
end