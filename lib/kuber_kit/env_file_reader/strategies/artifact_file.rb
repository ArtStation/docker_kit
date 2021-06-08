class KuberKit::EnvFileReader::Strategies::ArtifactFile < KuberKit::EnvFileReader::Strategies::Abstract
  include KuberKit::Import[
    "core.artifact_store",
    "env_file_reader.env_file_parser"
  ]

  def read(shell, env_file)
    artifact = artifact_store.get(env_file.artifact_name)

    file_parts = [artifact.cloned_path, env_file.file_path].compact
    file_path  = File.join(*file_parts)

    read_file(shell, file_path)
  end

  private
    def read_file(shell, file_path)
      result = {}
      content = shell.read(file_path)
      env_file_parser.call(content)
    end
end