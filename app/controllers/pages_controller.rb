# frozen_string_literal: true

class PagesController < ApplicationController
  before_action :admin_user, only: %w[edit create update destroy new]
  before_action :static_pages
  before_action :set_page, only: %w[show edit destroy update]

  def show; end

  def new
    @page = Page.new
  end

  def edit; end

  def update
    if @page.update(page_params)
      redirect_to page_path(@page.slug), notice: 'ページを更新しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def create
    @page = Page.new(page_params)

    if @page.save
      redirect_to page_path(@page.slug), notice: 'ページを作成しました'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @page.destroy

    redirect_to new_page_path, notice: 'ページを削除しました'
  end

  private

  def set_page
    @page = Page.find_by(slug: params[:slug])
  end

  def page_params
    params.require(:page).permit(:title, :slug, :content)
  end

  def admin_user
    return if current_user.admin?

    redirect_to root_path, notice: '管理者権限が必要です'
  end
end
