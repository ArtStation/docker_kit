class KuberKit::TemplateReader::Reader
  ReaderNotFoundError = Class.new(KuberKit::NotFoundError)

  include KuberKit::Import[
    "template_reader.strategies.artifact_file",
  ]

  def initialize(**injected_deps, &block)
    super(**injected_deps)
    add_default_strategies
  end

  def use_reader(template_reader, template_class:)
    @@readers ||= {}

    if !template_reader.is_a?(KuberKit::TemplateReader::Strategies::Abstract)
      raise ArgumentError.new("should be an instance of KuberKit::TemplateReader::Strategies::Abstract, got: #{template_reader.inspect}")
    end

    @@readers[template_class] = template_reader
  end

  def read(shell, template)
    reader = @@readers[template.class]

    raise ReaderNotFoundError, "Can't find reader for template #{template}" if reader.nil?

    reader.read(shell, template)
  end

  def reset!
    @@readers = {}
  end

  private
    def add_default_strategies
      use_reader(artifact_file, template_class: KuberKit::Core::Templates::ArtifactFile)
    end
end