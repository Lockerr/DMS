class Communication < ActiveRecord::Base
  belongs_to :person

  def action_time=(value)
    unless value.empty?
      time = value.split(/\D/)
      self.action_date = Date.today + time[0].to_i.hours
      self.action_date += time[1].to_i.minutes if time[1]
    end
  end

  def action_time
    return nil unless self.action_date
    self.action_date.to_s.split(/\ /)[1].split(':')[0..1].join(':')
  end

  def next_action_time
    return nil unless self.next_action_date
    self.next_action_date.to_s.split(/\ /)[1].split(':')[0..1].join(':')
  end

  def next_action_time=(value)
    unless value.empty?
      time = value.split(/\D/)
      self.next_action_date += time[0].to_i.hours
      self.next_action_date += time[1].to_i.minutes if time[1]
    end
  end
end
