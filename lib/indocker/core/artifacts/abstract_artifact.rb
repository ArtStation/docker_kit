class Indocker::Core::Artifacts::AbstractArtifact
  include Indocker::Extensions::Inspectable

  attr_reader :name

  def initialize(artifact_name)
    @name = artifact_name
  end

  def namespace
    raise Indocker::NotImplementedError, "must be implemented"
  end
end