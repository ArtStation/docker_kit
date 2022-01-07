class KuberKit::Core::ArtifactPathResolver < KuberKit::EnvFileReader::Strategies::Abstract
  include KuberKit::Import[
    "core.artifact_store"
  ]

  Contract KuberKit::Core::ArtifactPath => String
  def call(artifact_path)
    artifact = artifact_store.get(artifact_path.artifact_name)

    file_parts = [artifact.cloned_path, artifact_path.file_path].compact
    File.join(*file_parts)
  end
end