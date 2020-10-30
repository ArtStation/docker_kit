class KuberKit::Core::Service
  attr_reader :name, :template_name, :tags

  Contract KeywordArgs[
    name:           Symbol,
    template_name:  Symbol,
    tags:           ArrayOf[Symbol],
  ] => Any
  def initialize(name:, template_name:, tags:)
    @name = name
    @template_name = template_name
    @tags = tags
  end

  def uri
    name.to_s.sub("_", "-")
  end
end