class KuberKit::Core::Service
  AttributeNotSet = Class.new(KuberKit::Error)

  attr_reader :name, :initializers, :template_name, :tags, :images, :attributes, :deployer_strategy

  Contract KeywordArgs[
    name:               Symbol,
    initializers:       ArrayOf[Symbol],
    template_name:      Maybe[Symbol],
    tags:               ArrayOf[Symbol],
    images:             ArrayOf[Symbol],
    attributes:         HashOf[Symbol => Any],
    deployer_strategy:  Maybe[Symbol]
  ] => Any
  def initialize(name:, initializers:, template_name:, tags:, images:, attributes:, deployer_strategy:)
    @name = name
    @initializers = initializers
    @template_name = template_name
    @tags = tags
    @images = images
    @attributes = attributes
    @deployer_strategy = deployer_strategy
  end

  def uri
    name.to_s.gsub("_", "-")
  end

  def attribute(attribute_name, default: nil)
    if !attributes.has_key?(attribute_name.to_sym) && default.nil?
      raise AttributeNotSet, "attribute #{attribute_name} was not set"
    end

    if !attributes.has_key?(attribute_name.to_sym) && !default.nil?
      return default
    end

    attributes[attribute_name.to_sym]
  end
end