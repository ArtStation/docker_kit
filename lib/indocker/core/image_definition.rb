class Indocker::Core::ImageDefinition
  def initialize(image_name)
    @image_name = image_name
  end

  def to_image
    OpenStruct.new(
      name: @image_name,
      dependent_image_names: get_value(@dependent_image_names),
      registry_name:         get_value(@registry_name)
    )
  end

  def depends_on(dependent_image_names = nil, &block)
    @dependent_image_names = dependent_image_names ? Array(dependent_image_names) : block

    self
  end

  def registry(registry_name = nil, &block)
    @registry_name = registry_name ? registry_name : block

    self
  end

  private
    def get_value(variable)
      variable.is_a?(Proc) ? variable.call : variable
    end
end