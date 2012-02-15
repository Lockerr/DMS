class Asset < ActiveRecord::Base
  has_attached_file :data,
                    :url  => "/assets/:id",
                    :path => ":rails_root/assets/photos/:id/:style/:basename.:extension"

  belongs_to :attachable, :polymorphic => true

  def url(*args)
    data.url(*args)
  end

  def name
    data_file_name
  end

  def content_type
    data_content_type
  end

  def file_size
    data_file_size
  end
end
