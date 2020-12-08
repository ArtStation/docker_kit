class KuberKit::Core::ImageDefinition
  attr_reader :image_name, :path,
              :dependencies, :registry_name, :dockerfile_path,
              :build_vars, :build_context_dir, :tag, 
              :before_build_callback, :after_build_callback
  
  Contract Or[Symbol, String], Maybe[String] => Any
  def initialize(image_name, image_dir)
    @image_name   = image_name.to_sym
    @image_dir    = image_dir
    @dependencies = []
  end

  def to_image_attrs
    OpenStruct.new(
      name:                   @image_name,
      dir:                    @image_dir,
      dependencies:           @dependencies,
      registry_name:          get_value(@registry_name),
      dockerfile_path:        get_value(@dockerfile_path),
      build_vars:             get_value(@build_vars),
      build_context_dir:      get_value(@build_context_dir),
      tag:                    get_value(@tag),
      before_build_callback:  @before_build_callback,
      after_build_callback:   @after_build_callback
    )
  end

  def depends_on(*value, &block)
    @dependencies = Array(value).flatten
    self
  end

  def registry(value = nil, &block)
    @registry_name = block_given? ? block : value

    self
  end

  def dockerfile(value = nil, &block)
    @dockerfile_path = block_given? ? block : value

    self
  end

  def build_args(value = nil, &block)
    puts "WARNING: build_args is deprecated, please use build_vars instead"
    build_vars(value, *block)
  end

  def build_vars(value = nil, &block)
    @build_vars = block_given? ? block : value

    self
  end

  def build_context(value = nil, &block)
    @build_context_dir = block_given? ? block : value

    self
  end

  def tag(value = nil, &block)
    @tag = block_given? ? block : value

    self
  end

  def before_build(lambda_arg = nil, &block)
    @before_build_callback = lambda_arg || block

    self
  end

  def after_build(lambda_arg = nil, &block)
    @after_build_callback = lambda_arg || block

    self
  end

  private
    def get_value(variable)
      variable.is_a?(Proc) ? variable.call : variable
    end
end