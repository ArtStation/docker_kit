class KuberKit::Core::ContextHelper::ContextVars
  attr_reader :parent, :parent_name

  def initialize(context_vars, parent_name = nil, parent = nil)
    @context_vars = context_vars
    @parent_name  = parent_name
    @parent = parent
  end

  def method_missing(name, *args)
    if args.size > 0
      raise ArgumentError.new("context args does not accept any arguments")
    end

    value = @context_vars.fetch(name) do
      raise(KuberKit::Error, "build arg '#{format_arg(name)}' is not defined, available args: #{@context_vars.inspect}")
    end

    if value.is_a?(Hash)
      return self.class.new(value, name, self)
    end

    value
  end

  def to_h
    if @context_vars.is_a?(Hash)
      return @context_vars
    else
      return {value: @context_vars}
    end
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