class Indocker::Core::ImageDefinition
  def initialize(image_name)
    @image_name = image_name
  end

  def to_image
    OpenStruct.new(
      name: @image_name,
      dependent_image_names: get_value(@dependent_image_names),
      registry_name:         get_value(@registry_name),
      dockerfile_path:       get_value(@dockerfile_path),
      build_args:            get_value(@build_args)
    )
  end

  def depends_on(value = nil, &block)
    @dependent_image_names = value ? Array(value) : block

    self
  end

  def registry(value = nil, &block)
    @registry_name = value ? value : block

    self
  end

  def dockerfile(value = nil, &block)
    @dockerfile_path = value ? value : block

    self
  end

  def build_args(value = nil, &block)
    @build_args = value ? value : block

    self
  end

  private
    def get_value(variable)
      variable.is_a?(Proc) ? variable.call : variable
    end
end