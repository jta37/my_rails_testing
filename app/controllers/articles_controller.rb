class ArticlesController < ApplicationController

  # This method has to be in a controller.  It only runs this method if
  # => we are trying to go to a :destroy, :update, or :edit page.
  before_filter :find_user_article, only: [:destroy, :update, :edit]
  # The before logged_in? => you have to be logged in to access/view
  # => anything in this controller
  before_filter :logged_in? 
  def index
    # Article.all pulls all of the articles from the database, stores in @articles
    @articles = Article.all
    @articles.each do |article|
      if article.content.length > 500
        article.get_keywords  
      end
    end
  end

  def new
    @new_article = Article.new
  end

  def create
    @article = current_user.articles.create(article_params)
    if @article
      redirect_to article_path(@article.id)
    else
      redirect_to new_article_path
    end
  end

  def show
    find_article
    if @article.content.length > 500
      @article.get_keywords  
    end
  end

  def edit
    # the before_filter references the private method def find_user_article
    # => and our edit method inherits the @article instance and params 
  end

  def update
    @article.update(article_params)
    redirect_to article_path(@article.id)
  end

  def delete
    @article.destroy
    redirect_to articles_path
  end


  private
    def find_user_article
      @article = current_user.articles.find_by({id: params[:id]})
      unless @article
        redirect_to user_path(current_user)
      else
        @article
      end
    end

    def find_article
      @article = Article.find_by({id: params[:id]})
    end

    def article_params
      params.require(:article).permit(:title, :content)
    end
end
