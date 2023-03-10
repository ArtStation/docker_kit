require 'ostruct'
class KuberKit::Core::ContextHelper::ContextVars
  attr_reader :parent, :parent_name

  BuildArgUndefined = Class.new(KuberKit::Error)

  def initialize(context_vars, parent_name = nil)
    @context_vars = context_vars
    @parent_name  = parent_name
  end

  def read(*variable_names, default: nil)
    dig(*variable_names)
  rescue BuildArgUndefined
    return default
  end

  def dig(*variable_names)
    result = self
    variable_names.each do |var|
      result = result.get_variable_value(var)
    end
    result
  end

  def variable_defined?(*variable_names)
    dig(*variable_names)
    return true
  rescue BuildArgUndefined
    return false
  end

  def method_missing(name, *args)
    if args.size > 0
      raise ArgumentError.new("context args does not accept any arguments")
    end

    dig(name)
  end

  def keys
    @context_vars.keys
  end

  def to_h
    values = keys.map do |key|
      value = get_variable_value(key)
      hash_value = value.respond_to?(:to_h) ? value.to_h : value
      [key, hash_value]
    end
    Hash[values]
  end

  def to_struct
    values = keys.map do |key|
      value = get_variable_value(key)
      hash_value = value.respond_to?(:to_struct) ? value.to_struct : value
      [key, hash_value]
    end
    hash = Hash[values]
    OpenStruct.new(hash)
  end

  def get_variable_value(variable_name)
    value = @context_vars.fetch(variable_name) do
      raise(BuildArgUndefined, "build arg '#{format_arg(variable_name)}' is not defined, available args: #{@context_vars.inspect}")
    end

    if value.is_a?(Hash)
      return self.class.new(value, format_arg(variable_name))
    end

    value
  end

  private
    

    def format_arg(name)
      [@parent_name, name].compact.join(".")
    end
end