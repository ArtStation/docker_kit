class TestImageDefinitionFactory
  def create(image_name, image_dir = nil)
    KuberKit::Core::ImageDefinition
      .new(image_name, image_dir || "/images/#{image_name}")
  end
end