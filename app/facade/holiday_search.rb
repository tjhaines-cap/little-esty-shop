require './app/service/esty_service'
require './app/poro/holiday.rb'

class HolidaySearch 

  def next_3_holidays
    holiday_response = service.upcoming_holidays.first(3)
    holiday_response.map do |holiday_hash|
      Holiday.new(holiday_hash)
    end
  end

  def service
    EstyService.new
  end

end