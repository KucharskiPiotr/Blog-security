class ApplicationController < ActionController::Base
    def index
        @articles = Article.all
    end

  def search
    if params[:title].present?
        # To exploit that query run eg. "' UNION SELECT login as title, password as body FROM USERS where '1%'='1"
        @articles = ActiveRecord::Base.connection.execute("SELECT title FROM articles WHERE title LIKE '%#{params[:title]}%'")
        @query = params[:title]
    end
    
    render action: :search
  end

  def safe_search
    if params[:title].present?
        @articles = Article.where('title LIKE ?', "%#{params[:title]}%")
        @query = params[:title]
    end

    render action: :search_safe
  end

end
