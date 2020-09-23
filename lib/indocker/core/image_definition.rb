class Indocker::Core::ImageDefinition
  attr_reader :image_name, 
              :dependent_images, :registry_name, :dockerfile_path,
              :build_args, :build_context_dir, :tag, 
              :before_build_callback, :after_build_callback
  
  def initialize(image_name)
    @image_name = image_name
  end

  class ImageAttributes < Dry::Struct
    attribute :name,                  Types::Coercible::Symbol
    attribute :dependent_images,      Types::Array.of(Types::Coercible::Symbol).optional
    attribute :registry_name,         Types::Coercible::Symbol.optional
    attribute :dockerfile_path,       Types::Coercible::String.optional
    attribute :build_args,            Types::Hash.optional
    attribute :build_context_dir,     Types::Coercible::String.optional
    attribute :tag,                   Types::Coercible::String.optional
    attribute :before_build_callback, Types.Instance(Proc).optional
    attribute :after_build_callback,  Types.Instance(Proc).optional
  end

  def to_image_attrs
    ImageAttributes.new(
      name:                   @image_name,
      dependent_images:       get_value(@dependent_images),
      registry_name:          get_value(@registry_name),
      dockerfile_path:        get_value(@dockerfile_path),
      build_args:             get_value(@build_args),
      build_context_dir:      get_value(@build_context_dir),
      tag:                    get_value(@tag),
      before_build_callback:  @before_build_callback,
      after_build_callback:   @after_build_callback
    )
  end

  def depends_on(value = nil, &block)
    @dependent_images = value ? Array(value) : block

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

  def build_context(value = nil, &block)
    @build_context_dir = value ? value : block

    self
  end

  def tag(value = nil, &block)
    @tag = value ? value : block

    self
  end

  def before_build(&block)
    @before_build_callback = block

    self
  end

  def after_build(&block)
    @after_build_callback = block

    self
  end

  private
    def get_value(variable)
      variable.is_a?(Proc) ? variable.call : variable
    end
end