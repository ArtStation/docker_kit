class Indocker::Core::ImageDefinitionFactory
  def create(image_name)
    Indocker::Core::ImageDefinition.new(image_name)
  end
end