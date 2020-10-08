class Indocker::Core::Artifacts::ArtifactStore
  NotFoundError = Class.new(Indocker::NotFoundError)
  AlreadyAddedError = Class.new(Indocker::Error)

  include Indocker::Import[
    "shell.local_shell"
  ]

  def add(artifact)
    @@artifacts ||= {}

    if !artifact.is_a?(Indocker::Core::Artifacts::AbstractArtifact)
      raise ArgumentError.new("should be an instance of Indocker::Core::Artifacts::AbstractArtifact, got: #{artifact.inspect}")
    end

    unless @@artifacts[artifact.artifact_name].nil?
      raise AlreadyAddedError, "artifact #{artifact.artifact_name} was already added"
    end

    @@artifacts[artifact.artifact_name] = artifact
  end

  def get(artifact_name)
    artifact = get_from_configuration(artifact_name) || 
               get_global(artifact_name)

    artifact
  end

  def get_global(artifact_name)
    @@artifacts ||= {}
    artifact = @@artifacts[artifact_name]

    if artifact.nil?
      raise NotFoundError, "artifact #{artifact_name} not found"
    end
    
    artifact
  end

  def get_from_configuration(artifact_name)
    artifacts = Indocker.current_configuration.artifacts
    artifacts[artifact_name]
  end

  def reset!
    @@artifacts = {}
  end
end