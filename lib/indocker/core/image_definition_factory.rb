class Indocker::Core::ImageDefinitionFactory
  def create(image_name, image_dir)
    Indocker::Core::ImageDefinition.new(image_name, image_dir)
  end
end