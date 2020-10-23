class Indocker::Core::ServiceDefinition
  attr_reader :service_name
  
  Contract Or[Symbol, String] => Any
  def initialize(service_name)
    @service_name = service_name.to_sym
  end

  def to_service_attrs
    OpenStruct.new(
      name:         @service_name
    )
  end

  private
    def get_value(variable)
      variable.is_a?(Proc) ? variable.call : variable
    end
end