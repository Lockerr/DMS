# encoding: utf-8
if Rails.env == 'production'
  unless self.private_methods.include? 'irb_binding'
    task_scheduler = Rufus::Scheduler.start_new

    task_scheduler.in('1s') do
      Rails.logger.info 'Sheduler initiated'
      puts '1'
      Mbr.nal
    end

    # task_scheduler.cron('0 0-6 * * *') do
    #   Rails.logger.info 'Starting mbr parse'
    #   Car.mbr
    #   Rails.logger.info 'Ending mbr parse'
    # end

    task_scheduler.every('1h') do
      Rails.logger 'starting nal parsing'
      Mbr.nal
      Rails.logger 'nal parsing over'
    end

    def task_scheduler.handle_exception(job, exception)
      puts "job #{job.job_id} caught exception '#{exception}'"
      Rails.logger.info "job #{job.job_id} caught exception '#{exception}'"
    end



  end
end

