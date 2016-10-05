class BookingsController < ApplicationController

	before_action :find_company
	load_and_authorize_resource :booking
	def index
		if @company.is_resource_available?
			@bookings = @company.bookings.where("date_of_booking >= ?",Date.today)
			@ongoing_bookings = Booking.ongoing_bookings(current_employee.company)
		end
	end

	def new
		if @company.is_resource_available?
			@booking = current_employee.bookings.build
			@resource = Resource.all
		end
	end

	def create
		@booking = current_employee.bookings.build(booking_params)
		@booking.company_id = current_employee.company_id
		if  @booking.save
			flash[:success] = "Your booking is done"
			redirect_to bookings_path
		else
			render :new	
		end
	end

	def show
		@booking = @company.bookings.find(params[:id])
	end

	def edit
		@booking = @company.bookings.find(params[:id])
	end

	def update
		@booking = @company.bookings.find(params[:id])
		if @booking.update_attributes(booking_params)
			flash[:success] = "Your booking is successfully updated"
			redirect_to @booking
		else
			flash[:success] = "Error while updating booking"
			render :edit
		end
	end

	def destroy
		if @company.bookings.destroy(params[:id])
			flash[:success] = "Booking is successfully delted"
		else
			flash[:success] = "Error while deleting booking"
		end
			redirect_to bookings_path

	end
	
	def resource_time_slot
		@resource = @company.resources.find_by_name(params[:name])
	end

	def booking_date_slots
		resource = @company.resources.find_by_name(params[:resource])
		@slot_array = resource.available_time_slot params[:date_of_booking]
	end

	private

	def booking_params
		params.require(:booking).permit(:comment,:slot, :date_of_booking,:resource_id)
	end
	
end


