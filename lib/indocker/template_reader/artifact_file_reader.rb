class Indocker::TemplateReader::ArtifactFileReader < Indocker::TemplateReader::AbstractTemplateReader
  include Indocker::Import[
    "core.artifact_store",
    "preprocessing.text_preprocessor"
  ]

  def read(shell, env_file, context_helper: nil)
    artifact = artifact_store.get(env_file.artifact_name)

    file_parts = [artifact.cloned_path, env_file.file_path].compact
    file_path  = File.join(*file_parts)

    read_file(shell, file_path, context_helper: context_helper)
  end

  private
    def read_file(shell, file_path, context_helper:)
      result = {}
      content = shell.read(file_path)
      text_preprocessor.compile(content, context_helper: context_helper)
    end
end