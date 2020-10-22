class Indocker::EnvFileReader::Reader
  ReaderNotFoundError = Class.new(Indocker::NotFoundError)

  include Indocker::Import[
    "env_file_reader.artifact_file_reader",
  ]

  def use_reader(env_file_reader, env_file_class:)
    @@readers ||= {}

    if !env_file_reader.is_a?(Indocker::EnvFileReader::AbstractEnvFileReader)
      raise ArgumentError.new("should be an instance of Indocker::EnvFileReader::AbstractEnvFileReader, got: #{env_file_reader.inspect}")
    end

    @@readers[env_file_class] = env_file_reader
  end

  def read(shell, env_file)
    add_default_readers

    reader = @@readers[env_file.class]

    raise ReaderNotFoundError, "Can't find reader for env file #{env_file}" if reader.nil?

    reader.read(shell, env_file)
  end

  def add_default_readers
    use_reader(artifact_file_reader, env_file_class: Indocker::Core::EnvFiles::ArtifactFile)
  end

  def reset!
    @@readers = {}
  end
end