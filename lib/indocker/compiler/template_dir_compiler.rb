class Indocker::Compiler::TemplateDirCompiler
  include Indocker::Import[
    "compiler.template_file_compiler",
    "shell.bash_commands"
  ]

  def compile(shell, source_dir, destination_dir, context_helper: nil)
    copy_dir(shell, source_dir, destination_dir)
    compile_templates(shell, destination_dir, context_helper: context_helper)
  end

  private
    def copy_dir(shell, source_dir, destination_dir)
      bash_commands.rm_rf(shell, destination_dir)
      bash_commands.cp_r(shell, source_dir, destination_dir)
    end

    def compile_templates(shell, templates_dir, context_helper:)
      shell.recursive_list_files(templates_dir).each do |file_path|
        template_file_compiler.compile(shell, file_path, context_helper: context_helper)
      end
    end
end