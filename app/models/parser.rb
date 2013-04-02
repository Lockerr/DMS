module Parser
  def self.rearrange_models
    Model.find_each do |model|
      next if model.name.scan('VIANO').any?
      next if model.name.empty?
      next if model.name.scan('VITO').any?
      next if model.name.match(/^\d+$/)
      model.update_attributes(name: model.name.scan(/([\w]{1,3}?)\s?(\d{2,3})|(VIANO)\s(\w+)/)[0].delete_if(&:nil?)[1])
    end
  end

  def self.point_assign()
end
  def self.unique_models
    Model.group([:name, :klasse_id]).each do |model|
      models = Model.where(name: model.name, klasse_id: model.klasse_id)
      next if models.size < 1
      models[1..-1].each do |douplicate|
        models.first.cars << douplicate.cars
        douplicate.destroy
      end
    end
  end

  def self.remove_empty_models
    Model.find_each do |model|
      model.destroy if model.cars.count == 0
    end
  end

end