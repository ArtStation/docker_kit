class KuberKit::Core::Templates::AbstractTemplate
  include KuberKit::Extensions::Inspectable

  attr_reader :name

  def initialize(template_name)
    @name = template_name
  end
end