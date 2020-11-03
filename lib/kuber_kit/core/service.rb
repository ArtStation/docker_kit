class KuberKit::Core::Service
  AttributeNotSet = Class.new(Indocker::Error)

  attr_reader :name, :template_name, :tags, :images, :attributes

  Contract KeywordArgs[
    name:           Symbol,
    template_name:  Symbol,
    tags:           ArrayOf[Symbol],
    images:         ArrayOf[Symbol],
    attributes:     HashOf[Symbol => Any],
  ] => Any
  def initialize(name:, template_name:, tags:, images:, attributes:)
    @name = name
    @template_name = template_name
    @tags = tags
    @images = images
    @attributes = attributes
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