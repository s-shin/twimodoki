class SearchController < ApplicationController
  def index
    redirect_to search_users_url
  end

  def users
    @query = params[:q]
    if @query
      page = params[:page] ? params[:page] : 1
      @results = User.where("name like ? or another_name like ?", "%#{@query}%", "%#{@query}%").page(page).per(10)
    end
  end
end
