class SearchController < ApplicationController
  def index
    @results = SearchService.call(params[:query], params[:resource])

  rescue StandardError => e
    redirect_to root_path
    flash[:alert] = e.message
  end

  private

  def query_params
    params.permit(:query, :resource)
  end
end