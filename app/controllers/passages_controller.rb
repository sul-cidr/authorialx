class PassagesController < ApplicationController
  # respond_to :json

  def index


    @passages = Passage.order(:work_id).all

    #
    if params[:q]
      @passages = Passage.search(:include => [:text]) do
        keywords(params[:q])
      end

    end
  end

  def new
    @passage = Passage.new
  end

  def create
    @passage = Passage.new passage_params
    @passage.save
  end

end
