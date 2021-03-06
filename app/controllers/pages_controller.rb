class PagesController < ApplicationController

  before_action :authenticate_user!, except: [:blog, :show]
  before_action ->{ raise CanCan::AccessDenied if !action_name.in?(%w(blog show)) && cannot?(:manage, Page) }
  before_action :set_page, only: [:show, :edit, :update, :destroy]

  # GET /pages
  def index
    @pages = Page.latest.page(params[:page]).per(20).decorate
  end

  # GET /blog
  def blog
    @pages = Page.latest_blog_posts.page(params[:page]).per(5).decorate
  end

  # GET /pages/1
  def show
  end

  # GET /pages/new
  def new
    @page = Page.new
  end

  # GET /pages/1/edit
  def edit
  end

  # POST /pages
  def create
    @page = Page.new(page_params)

    if @page.save
      redirect_to @page, notice: 'Страница успешно создана.'
    else
      render :new
    end
  end

  # PATCH/PUT /pages/1
  def update
    if @page.update(page_params)
      redirect_to @page, notice: 'Страница успешно обновлена.'
    else
      render :edit
    end
  end

  # DELETE /pages/1
  def destroy
    # @page.destroy
    @page.update_attribute(:state, Page.states[:deleted])
    redirect_to pages_url, notice: 'Страница успешно удалена.'
  end

  private
    def set_page
      relation = Page.where("id = CAST(? AS numeric) OR alias = ?", params[:id].to_i, params[:id].to_s)
      relation = relation.blog_posts if route_name == :blog_post
      relation = relation.published unless can?(:manage, Page)
      @page = relation.first!.decorate
    end

    def page_params
      params.require(:page).permit(:title, :text, :category, :state, :alias)
    end

    def route_name
      Rails.application.routes.router.recognize(request) do |route, _|
        return route.name.to_sym  if route.name
      end
    end
end
