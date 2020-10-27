class Indocker::Core::Service
  attr_reader :name, :template_name

  Contract KeywordArgs[
    name:               Symbol,
    template_name:      Symbol,
  ] => Any
  def initialize(name:, template_name:)
    @name = name
    @template_name = template_name
  end
end