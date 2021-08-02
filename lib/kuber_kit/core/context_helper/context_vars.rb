class KuberKit::Core::ContextHelper::ContextVars
  attr_reader :parent, :parent_name

  BuildArgUndefined = Class.new(KuberKit::Error)

  def initialize(context_vars, parent_name = nil, parent = nil)
    @context_vars = context_vars
    @parent_name  = parent_name
    @parent = parent
  end

  def read(*variable_names)
    result = self
    variable_names.each do |var|
      result = result.get_variable_value(var)
    end
    result
  end

  def variable_defined?(*variable_names)
    read(*variable_names) 
    return true
  rescue BuildArgUndefined
    return false
  end

  def method_missing(name, *args)
    if args.size > 0
      raise ArgumentError.new("context args does not accept any arguments")
    end

    read(name)
  end

  def to_h
    if @context_vars.is_a?(Hash)
      return @context_vars
    else
      return {value: @context_vars}
    end
  end

  def get_variable_value(variable_name)
    value = @context_vars.fetch(variable_name) do
      raise(BuildArgUndefined, "build arg '#{format_arg(variable_name)}' is not defined, available args: #{@context_vars.inspect}")
    end

    if value.is_a?(Hash)
      return self.class.new(value, variable_name, self)
    end

    value
  end

  private

    def format_arg(name)
      string = [@parent_name, name].compact.join(".")
      parent = @parent

      while parent do
        string = [parent.parent_name, string].compact.join(".")
        parent = parent.parent
      end

      string
    end
end