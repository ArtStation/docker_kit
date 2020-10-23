class Indocker::TemplateReader::Reader
  ReaderNotFoundError = Class.new(Indocker::NotFoundError)

  include Indocker::Import[
    "template_reader.artifact_file_reader",
    "core.context_helper_factory",
  ]

  def use_reader(template_reader, template_class:)
    @@readers ||= {}

    if !template_reader.is_a?(Indocker::TemplateReader::AbstractTemplateReader)
      raise ArgumentError.new("should be an instance of Indocker::TemplateReader::AbstractTemplateReader, got: #{template_reader.inspect}")
    end

    @@readers[template_class] = template_reader
  end

  def read(shell, template)
    add_default_readers

    reader = @@readers[template.class]

    raise ReaderNotFoundError, "Can't find reader for template #{template}" if reader.nil?

    context_helper = context_helper_factory.create(shell)

    reader.read(shell, template, context_helper: context_helper)
  end

  def add_default_readers
    use_reader(artifact_file_reader, template_class: Indocker::Core::Templates::ArtifactFile)
  end

  def reset!
    @@readers = {}
  end
end