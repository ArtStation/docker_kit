class Indocker::Core::Templates::AbstractTemplate
  include Indocker::Extensions::Inspectable

  attr_reader :template_name

  def initialize(template_name)
    @template_name = template_name
  end
end