require 'erb'

class Indocker::Preprocessing::TextPreprocessor
  def compile(template, context_helper: nil)
    ERB.new(template).result(context_helper&.get_binding)
  end
end