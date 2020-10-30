class DockerKit::Core::Artifacts::AbstractArtifact
  include DockerKit::Extensions::Inspectable

  attr_reader :name

  def initialize(artifact_name)
    @name = artifact_name
  end

  def namespace
    raise DockerKit::NotImplementedError, "must be implemented"
  end
end