#encoding: utf-8
class LeadMailer < ActionMailer::Base
  include Devise::Mailers::Helpers

  default from: "do-not-replay@rosfax.ru"

  def new_lead_notification(record)
    @lead = record
    mail(:to => 'lockerr@mail.ru', subject: 'УАХ мобильный, новый lead.')
  end
end
