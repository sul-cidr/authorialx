class SearchController < ApplicationController

  def index
  # def search
    if params[:q].nil?
      @passages = []
    else
      # @passages = Passage.search do
      @passages = Sunspot.search Passage do
        fulltext params[:q] do
          highlight :text, :fragment_size => 200
        end

      end

    end
  end
end
