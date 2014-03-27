class Event < ActiveRecord::Base


  def self.list_by(condition)
    Event.where(condition).order(start_dt: :asc, start_tm: :asc)
  end

  def self.current
    current_date = 'start_dt >= ?', Date.today
    self.list_by(current_date)
  end

  def self.day
    all_day = 'start_dt = ?', Date.today
    self.list_by(all_day)
  end

  def self.week
    start_of_week = Date.today - (Date.today.cwday - 1).abs
    end_of_week = Date.today + (7 - Date.today.cwday).abs

    all_week = 'start_dt BETWEEN ? AND ?', start_of_week, end_of_week
    self.list_by(all_week)
  end

  def self.month
    start_of_month = Date.civil(Date.today.year, Date.today.month, 1)
    end_of_month = Date.civil(Date.today.year, Date.today.month, -1)

    all_month = 'start_dt BETWEEN ? AND ?', start_of_month, end_of_month
    self.list_by(all_month)
  end

  def self.previous_day
    date = Date.today - 1
    prev_day = 'start_dt = ?', date
    self.list_by(prev_day)
  end

end
