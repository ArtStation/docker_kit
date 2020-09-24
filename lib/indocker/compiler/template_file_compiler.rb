class Indocker::Compiler::TemplateFileCompiler
  include Indocker::Import["compiler.template_compiler"]

  def compile(shell, source_path, destination_path: nil, context_helper: nil)
    destination_path ||= source_path

    template = shell.read(source_path)
    content = template_compiler.compile(template, context_helper: context_helper)

    is_content_changed = template != content
    if !is_content_changed && source_path == destination_path
      return false
    end

    shell.write(destination_path, content)

    return true
  end
end