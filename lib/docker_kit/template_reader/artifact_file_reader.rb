class DockerKit::TemplateReader::ArtifactFileReader < DockerKit::TemplateReader::AbstractTemplateReader
  include DockerKit::Import[
    "core.artifact_store"
  ]

  def read(shell, env_file)
    artifact = artifact_store.get(env_file.artifact_name)

    file_parts = [artifact.cloned_path, env_file.file_path].compact
    file_path  = File.join(*file_parts)

    shell.read(file_path)
  end
end