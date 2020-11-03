class KuberKit::Core::Artifacts::ArtifactStore
  NotFoundError = Class.new(KuberKit::NotFoundError)
  AlreadyAddedError = Class.new(KuberKit::Error)

  def add(artifact)
    @@artifacts ||= {}

    if !artifact.is_a?(KuberKit::Core::Artifacts::AbstractArtifact)
      raise ArgumentError.new("should be an instance of KuberKit::Core::Artifacts::AbstractArtifact, got: #{artifact.inspect}")
    end

    unless @@artifacts[artifact.name].nil?
      raise AlreadyAddedError, "artifact #{artifact.name} was already added"
    end

    @@artifacts[artifact.name] = artifact
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
      raise NotFoundError, "artifact '#{artifact_name}' not found"
    end
    
    artifact
  end

  def get_from_configuration(artifact_name)
    artifacts = KuberKit.current_configuration.artifacts
    artifacts[artifact_name]
  end

  def reset!
    @@artifacts = {}
  end

  def all_definitions
    @@artifacts ||= {}
  end

  def exists?(artifact_name)
    !all_definitions[artifact_name].nil?
  end
end