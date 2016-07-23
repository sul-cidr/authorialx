class WorksController < ApplicationController
  # respond_to do |format|
  #   format.json
  # end

  def index
    works = Work.all.sort_by {|w| w.sortable_title}

    if params[:work_id]
      works = Work.where(:work_id => params[:work_id])
    end

    if params[:author_id]
      works = Work.by_author(params[:author_id])
    end

    if params[:work_cat]
      # works = Work.all.sort_by {|w| w.sortable_title}
      works = Work.joins{categories}.where('"categories"."category_id" IN (?)', params[:work_cat])

      # works = Work.joins{categories}.where{categories.category_id >> params[:work_cat]}
      # works = Work.joins{work_category_rels.category}.where{categories.category_id >> params[:work_cat]}
    end

    if params[:list]
      works = Work.all.select("title, work_id").sort_by {|w| w.sortable_title}
    end

    @works = works

  end

  def new
    @work = Work.new
  end

  def create
    @work = Work.new work_params
    @work.save
  end

  private

  def work_params
    # params.require(:work).permit!
  end

end
