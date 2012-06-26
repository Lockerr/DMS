# encoding: utf-8
if Rails.env == 'production'
  unless self.private_methods.include? 'irb_binding'
    task_scheduler = Rufus::Scheduler.start_new

    task_scheduler.in('1s') do
      Rails.logger.info 'Sheduler initiated'
      puts '1'
    end

    #task_scheduler.cron('*/1 * * * *') do
    #  Rails.logger.info 'storing orders'
    #  Order.store
    #  Rails.logger.info 'orders stored'
    #
    #end

    def task_scheduler.handle_exception(job, exception)
      puts "job #{job.job_id} caught exception '#{exception}'"
      Rails.logger.info "job #{job.job_id} caught exception '#{exception}'"
    end

  end
end