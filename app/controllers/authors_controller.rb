class AuthorsController < ApplicationController
  respond_to do |format|
    format.json { render json: @authors }
  end

  def index
    # exclude bio authors
    authors = Author.order(:surname).where('author_id not in (10002)')

    if params[:author_id]
      authors = Author.where(:author_id => params[:author_id])
    end

    if params[:auth_cat]
      counts = Work.rank_authors(params)
      authors = Author.where{ author_id >> counts.keys}
    end

    if params[:work_cat]
      counts = Work.rank_authors(params)
      authors = Author.where{ author_id >> counts.keys}
    end

    @authors = authors
  end

  def new
    @author = Author.new
  end

  def create
    @author = Author.new author_params
    @author.save
  end

  def author_params
    params.require(:author).permit(:image)
  end
  #
  # private
  #
  # def author_params
  #   params.require(:author).(:author_id, #:prefname,
  #     :surname, :middle, :given, :label, :birth_year, :death_year,
  #     :birth_date, :death_date)
  # end

end
