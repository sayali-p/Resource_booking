module Admin::ResourcesHelper


	def check_avability resource
		time_slot_array = resource.timeslots
		days_booking =	Booking.where("created_at >= ? and created_at<=?", Time.zone.now.beginning_of_day,Time.zone.now.end_of_day)
		puts "days_booking are #{days_booking.inspect}"
		if days_booking.any?
			days_booking.each{|x| time_slot_array.delete_at(x.slot) }
		end
		time_slot_array
	end

	



end
