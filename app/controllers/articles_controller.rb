# frozen_string_literal: true

class ArticlesController < ApplicationController
  before_action :set_article, only: [:show]
  before_action :article_params, only: [:create]
  load_and_authorize_resource only: %i[edit update destroy create]

  def index
    @articles = Article.paginate(page: params[:page], per_page: 5)
  end

  def new
    @article = Article.new
  end

  def edit; end

  def create
    @article = Article.new(article_params)
    @article.user_id = current_user.id
    if @article.save
      flash[:success] = 'article was successfully created'
      redirect_to article_path(@article)

    else
      render 'new'

    end
  end

  def update
    if @article.update(article_params)
      flash[:success] = 'article was successfuly updated'
      redirect_to article_path(@article)
    else
      render 'edit'
    end
  end

  def show; end

  def destroy
    @article.destroy
    flash[:danger] = 'Article was successfully deleted'
    redirect_to articles_path
  end

  private

  def article_params
    params.require(:article).permit(:title, :description, category_ids: [])
  end

  def require_same_user
    if (current_user != @article.user) && !current_user.admin?
      flash[:danger] = 'you can only edit or delete your own articles'
      redirect_to root_path
    end
  end

  def set_article
    @article = Article.find(params[:id])
  end
end
