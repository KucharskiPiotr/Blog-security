class ArticlesController < ApplicationController
  include ActionView::Helpers::SanitizeHelper

  before_action :set_article, only: %i[ show edit update destroy ]
  before_action :authenticate_user!
  
  # GET /articles or /articles.json
  def index
    @articles = Article.all
  end

  # GET /articles/1 or /articles/1.json
  def show
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles or /articles.json
  def create
    @article = Article.new(filtered_params)

    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: "Article was successfully created." }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1 or /articles/1.json
  def update
    respond_to do |format|
      if @article.update(filtered_params)
        format.html { redirect_to @article, notice: "Article was successfully updated." }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1 or /articles/1.json
  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_url, notice: "Article was successfully destroyed." }
      format.json { head :no_content }
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def article_params
      params.require(:article).permit(:title, :content, :user_id)
    end
    
    def filtered_params
      article_params.merge({ 
        user_id: current_user.id, 
        title: sanitize_title,
        content: sanitize_content 
      })
    end

    def sanitize_content
      sanitize article_params[:content], scrubber: image_scrubber
    end
    
    def sanitize_title
      sanitize article_params[:title]
    end
    
    def image_scrubber
      @scrubber ||= Loofah::Scrubber.new do |node|
        node.remove if node.name == 'script'
        node.remove if node.name == 'img' && !node["src"].starts_with?("https://www.pk.edu.pl/")
      end
    end
end
