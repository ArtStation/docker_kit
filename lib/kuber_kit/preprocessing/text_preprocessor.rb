require 'erb'

class KuberKit::Preprocessing::TextPreprocessor
  def compile(template, context_helper: nil)
    ERB.new(template, nil, '-').result(context_helper&.get_binding)
  end
end