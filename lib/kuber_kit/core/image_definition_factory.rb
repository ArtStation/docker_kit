class KuberKit::Core::ImageDefinitionFactory
  def create(image_name, image_dir)
    KuberKit::Core::ImageDefinition.new(image_name, image_dir)
  end
end