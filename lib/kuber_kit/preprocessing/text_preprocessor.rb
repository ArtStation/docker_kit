require 'erb'

class KuberKit::Preprocessing::TextPreprocessor
  def compile(template, context_helper: nil)
    ERB.new(template, trim_mode: '-').result(context_helper&.get_binding)
  end
end