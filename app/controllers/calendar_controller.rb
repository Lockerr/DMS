class CalendarController < ApplicationController
  def index
    m = current_user.manager
    @events = m.communications.where('next_action_date > ?', Time.now)
    @events_day = m.communications.where('next_action_date between ? and ?', Time.now, Time.now + 1.day).order(:next_action_date)

    @events_week = m.communications.where('next_action_date between ? and ?', Time.now, Time.now + 1.week).order(:next_action_date)

  end

  def day
    day = Time.now.at_beginning_of_year.utc + params[:id].to_i.days - 18.hours
    #raise current_user.manager.communications.where('next_action_date between ? and ?', day, day + 1.day - 1.second).order(:next_action_date).to_sql.inspect
    @events = current_user.manager.communications.where('next_action_date between ? and ?', day, day + 1.day - 1.second).order(:next_action_date)
  end

end
