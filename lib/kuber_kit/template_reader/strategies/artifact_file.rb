class KuberKit::TemplateReader::Strategies::ArtifactFile < KuberKit::TemplateReader::Strategies::Abstract
  include KuberKit::Import[
    "core.artifact_store"
  ]

  def read(shell, template)
    artifact = artifact_store.get(template.artifact_name)

    file_parts = [artifact.cloned_path, template.file_path].compact
    file_path  = File.join(*file_parts)

    shell.read(file_path)
  end
end