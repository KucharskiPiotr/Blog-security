class ApplicationController < ActionController::Base
    def index
        @articles = Article.all
    end

  def search
    return unless params[:title].present?

    # To exploit that query run eg. "' UNION SELECT login as title, password as body FROM USERS where '1%'='1"
    @articles = ActiveRecord::Base.connection.execute("SELECT title FROM articles WHERE title LIKE '%#{params[:title]}%'")
    puts 'Returned articles', @articles
    render "index"
  end

  def safe_search
    return unless params[:title].present?

    @articles = Article.where('title LIKE ?', "%#{params[:title]}%")
    render action: :index
  end

end
