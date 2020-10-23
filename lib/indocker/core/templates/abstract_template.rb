class Indocker::Core::Templates::AbstractTemplate
  include Indocker::Extensions::Inspectable

  attr_reader :name

  def initialize(template_name)
    @name = template_name
  end
end