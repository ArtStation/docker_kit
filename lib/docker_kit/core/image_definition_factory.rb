class DockerKit::Core::ImageDefinitionFactory
  def create(image_name, image_dir)
    DockerKit::Core::ImageDefinition.new(image_name, image_dir)
  end
end