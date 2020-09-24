require 'erb'

class Indocker::Compiler::TemplateCompiler
  def compile(template, context_helper: nil)
    ERB.new(template).result(context_helper&.get_binding)
  end
end