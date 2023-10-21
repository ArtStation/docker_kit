class KuberKit::Core::ContextHelper::LocalContextHelper < KuberKit::Core::ContextHelper::AbstractHelper
  def initialize(parent_context_helper:, variables:)
    @parent_context_helper = parent_context_helper
    @variables = variables
  end

  def method_missing(method_name, *args, &block)
    if @variables.has_key?(method_name)
      @variables[method_name]
    else
      @parent_context_helper.send(method_name, *args, &block)
    end
  end
end