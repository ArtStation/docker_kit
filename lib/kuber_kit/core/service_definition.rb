class KuberKit::Core::ServiceDefinition
  attr_reader :service_name, :template_name, :dependencies
  
  Contract Or[Symbol, String] => Any
  def initialize(service_name)
    @service_name = service_name.to_sym
    @dependencies = []
  end

  def to_service_attrs
    OpenStruct.new(
      name:               @service_name,
      dependencies:       @dependencies,
      template_name:      get_value(@template_name),
      tags:               Array(get_value(@tags)).map(&:to_sym),
      images:             Array(get_value(@images)).map(&:to_sym),
      attributes:         get_value(@attributes),
      deployer_strategy:  get_value(@deployer_strategy),
    )
  end

  def depends_on(*value, &block)
    @dependencies = Array(value).flatten
    self
  end

  def template(value = nil, &block)
    @template_name = block_given? ? block : value

    self
  end

  def tags(*value, &block)
    @tags = block_given? ? block : Array(value).flatten

    self
  end

  def images(*value, &block)
    @images = block_given? ? block : Array(value).flatten

    self
  end

  def attributes(value = nil, &block)
    @attributes = block_given? ? block : value

    self
  end

  def deployer_strategy(value = nil, &block)
    @deployer_strategy = block_given? ? block : value

    self
  end

  private
    def get_value(variable)
      variable.is_a?(Proc) ? variable.call : variable
    end
end