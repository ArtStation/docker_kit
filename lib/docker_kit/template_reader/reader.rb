class DockerKit::TemplateReader::Reader
  ReaderNotFoundError = Class.new(DockerKit::NotFoundError)

  include DockerKit::Import[
    "template_reader.artifact_file_reader",
  ]

  def use_reader(template_reader, template_class:)
    @@readers ||= {}

    if !template_reader.is_a?(DockerKit::TemplateReader::AbstractTemplateReader)
      raise ArgumentError.new("should be an instance of DockerKit::TemplateReader::AbstractTemplateReader, got: #{template_reader.inspect}")
    end

    @@readers[template_class] = template_reader
  end

  def read(shell, template)
    add_default_readers

    reader = @@readers[template.class]

    raise ReaderNotFoundError, "Can't find reader for template #{template}" if reader.nil?

    reader.read(shell, template)
  end

  def add_default_readers
    use_reader(artifact_file_reader, template_class: DockerKit::Core::Templates::ArtifactFile)
  end

  def reset!
    @@readers = {}
  end
end