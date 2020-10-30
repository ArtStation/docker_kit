class KuberKit::Core::Service
  attr_reader :name, :template_name, :tags, :images

  Contract KeywordArgs[
    name:           Symbol,
    template_name:  Symbol,
    tags:           ArrayOf[Symbol],
    images:         ArrayOf[Symbol],
  ] => Any
  def initialize(name:, template_name:, tags:, images:)
    @name = name
    @template_name = template_name
    @tags = tags
    @images = images
  end

  def uri
    name.to_s.gsub("_", "-")
  end
end