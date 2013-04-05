class Opt < ActiveRecord::Base
  belongs_to :klasse

  def self.remove_duplicates
    Opt.find_each do |opt|
      opts = Opt.where(code: opt.code, klasse_id: opt.klasse_id)
      if opts.count > 1
        opts.where('id <> ?', opt.id).destroy_all
      end
    end
  end

  def self.organize
    Opt.find_each do |opt|
      opts = Opt.where(code: opt.code, desc: opt.desc)
      next unless opts.count > 1
      opts.where('id <> ?', opt.id).delete_all
      opt.update_attributes klasse_id: nil
    end
  end
end
