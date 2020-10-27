class Indocker::Core::ServiceDefinition
  attr_reader :service_name, :template_name
  
  Contract Or[Symbol, String] => Any
  def initialize(service_name)
    @service_name = service_name.to_sym
  end

  def to_service_attrs
    OpenStruct.new(
      name:           @service_name,
      template_name:  get_value(@template_name)
    )
  end

  def template(value = nil, &block)
    @template_name = block_given? ? block : value

    self
  end

  private
    def get_value(variable)
      variable.is_a?(Proc) ? variable.call : variable
    end
end