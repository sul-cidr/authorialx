class AreasController < ApplicationController
	respond_to :json

	def index
    areas = Area.all

    # only those with places/placerefs in them (too expensive)
    # filter at Entity level instead
		# areas = Area.active

    if params[:area_type]
      areas = areas.of_type(params[:area_type])
    end

    # hoods within a borough
    if params[:in_id]
      areas = areas.child_of(params[:in_id])
    end

    # parent area (hood) for a place
    if params[:child]
      areas = Area.contains_place(params[:child])
    end

    @areas = areas
	end

  def new
    @area = Area.new
  end

  def create
    @area = Area.new area_params
    @area.save
  end

end
