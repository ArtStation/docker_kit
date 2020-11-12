class KuberKit::Preprocessing::DirPreprocessor
  include KuberKit::Import[
    "preprocessing.file_preprocessor",
    "shell.bash_commands",
    "shell.local_shell"
  ]

  def compile(shell, local_source_dir, remote_destination_dir, context_helper: nil)
    local_shell.recursive_list_files(local_source_dir).each do |source_file_path|
      relative_path = source_file_path.sub(local_source_dir, '')
      destination_file_path = File.join(remote_destination_dir, relative_path)

      shell.upload_file(source_file_path, destination_file_path)

      file_preprocessor.compile(
        shell, destination_file_path, 
        context_helper: context_helper
      )
    end
  end
end