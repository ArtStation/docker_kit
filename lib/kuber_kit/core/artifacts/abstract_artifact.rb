class KuberKit::Core::Artifacts::AbstractArtifact
  include KuberKit::Extensions::Inspectable

  attr_reader :name

  def initialize(artifact_name)
    @name = artifact_name
  end

  def namespace
    raise KuberKit::NotImplementedError, "must be implemented"
  end
end