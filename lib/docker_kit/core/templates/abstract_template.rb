class DockerKit::Core::Templates::AbstractTemplate
  include DockerKit::Extensions::Inspectable

  attr_reader :name

  def initialize(template_name)
    @name = template_name
  end
end