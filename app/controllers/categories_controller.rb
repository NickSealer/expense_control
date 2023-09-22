# frozen_string_literal: true

class CategoriesController < ApplicationController
  include AvatarConcern

  before_action :authenticate_user!
  before_action :category, only: %i[show edit update destroy]
  before_action :avatar, only: %i[create update]

  def index
    categories = params[:search].present? ? CategoriesQuery.search(current_user, params[:search]) : current_user.categories.includes(:parent).order(:name)
    @categories = categories.decorate
  end

  def new
    @category ||= current_user.categories.new
  end

  def create
    @category = current_user.categories.new(category_params)
    attach_avatar(@category)
    return render :new unless @category.save

    CategoryCreateMailerJob.perform_async(current_user.id, @category.id)
    redirect_to @category, notice: 'Category was successfully created.'
  end

  def update
    attach_avatar(@category)
    return render :edit unless @category.update(category_params)

    redirect_to @category, notice: 'Category was successfully updated.'
  end

  def destroy
    return redirect_to categories_url, alert: "Category #{@category.name} can\'t be deleted because there are associated expenses!" if @category.expenses.any?

    @category.avatar.purge
    @category.destroy!
    CategoryDeleteMailerJob.perform_async(current_user.id, @category.id)
    redirect_to categories_url, notice: 'Category was successfully destroyed.'
  end

  private

  def category
    @category ||= current_user.categories.find(params[:id]).decorate
  end

  def avatar
    @avatar ||= params[:category][:avatar]
  end

  def category_params
    params.require(:category).permit(:name, :description, :parent_id, :user_id)
  end
end
