class ApplicationController < ActionController::Base
  include ActionView::Helpers::SanitizeHelper
  def index
    @articles = Article.all
  end

  def search
    if params[:title].present?
      @articles = ActiveRecord::Base.connection.execute(
        "SELECT articles.id as id, title, username " + 
        "FROM articles JOIN users ON articles.user_id = users.id " + 
        "WHERE title LIKE '%#{params[:title]}%'"
      )
      @query = params[:title]
    end

    render action: :search
  end

  def safe_search
    if params[:title].present?
      @articles = Article.where('title LIKE ?', "%#{params[:title]}%")
      @query = sanitize params[:title]
    end

    render action: :search_safe
  end

end
