class KuberKit::EnvFileReader::Strategies::ArtifactFile < KuberKit::EnvFileReader::Strategies::Abstract
  include KuberKit::Import[
    "core.artifact_store",
    "env_file_reader.env_file_parser",
    "preprocessing.text_preprocessor"
  ]

  PREPROCESS_EXTENSIONS = [".erb"]

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
      enable_preprocessing = PREPROCESS_EXTENSIONS.any?{ |e| e == File.extname(file_path) }
      if enable_preprocessing
        content = text_preprocessor.compile(content)
      end

      env_file_parser.call(content)
    end
end