class Indocker::Core::Artifacts::AbstractArtifact
  include Indocker::Extensions::Inspectable

  attr_reader :artifact_name

  def initialize(artifact_name)
    @artifact_name = artifact_name
  end

  def namespace
    raise Indocker::NotImplementedError, "must be implemented"
  end
end