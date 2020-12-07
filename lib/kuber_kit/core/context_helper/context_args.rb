class KuberKit::Core::ContextHelper::ContextArgs
  attr_reader :parent, :parent_name

  def initialize(context_args, parent_name = nil, parent = nil)
    @context_args = context_args
    @parent_name  = parent_name
    @parent = parent
  end

  def method_missing(name, *args)
    if args.size > 0
      raise ArgumentError.new("context args does not accept any arguments")
    end

    value = @context_args.fetch(name) do
      raise(KuberKit::Error, "build arg '#{format_arg(name)}' is not defined, available args: #{@context_args.inspect}")
    end

    if value.is_a?(Hash)
      return self.class.new(value, name, self)
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