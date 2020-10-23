class Indocker::Core::Templates::ErbTemplate < Indocker::Core::Templates::AbstractTemplate
  attr_reader :content

  def initialize(template_name, content:)
    super(template_name)
    @content = content
  end
end