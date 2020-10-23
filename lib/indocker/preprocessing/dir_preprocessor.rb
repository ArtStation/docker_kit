class Indocker::Preprocessing::DirPreprocessor
  include Indocker::Import[
    "preprocessing.file_preprocessor",
    "shell.bash_commands"
  ]

  def compile(shell, source_dir, destination_dir, context_helper: nil)
    shell.recursive_list_files(source_dir).each do |source_file_path|
      relative_path = source_file_path.sub(source_dir, '')
      destination_file_path = File.join(destination_dir, relative_path)

      file_preprocessor.compile(
        shell, source_file_path, 
        destination_path: destination_file_path, 
        context_helper: context_helper
      )
    end
  end
end