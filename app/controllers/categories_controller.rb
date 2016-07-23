class CategoriesController < ApplicationController
  # respond_to do |format|
  #   format.json
  # end

  def index
    @categories = Category.joins(:dimension).order(:dimension_id, :sort).all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new category_params
    @category.save
  end

end
