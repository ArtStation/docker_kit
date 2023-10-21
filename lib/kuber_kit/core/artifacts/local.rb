class KuberKit::Core::Artifacts::Local < KuberKit::Core::Artifacts::AbstractArtifact
  def setup(root_path)
    @root_path = File.expand_path(root_path)
    self
  end

  def root_path
    @root_path || (raise ArgumentError.new("root path was not set. Set it using setup method"))
  end

  def cloned_path
    root_path
  end

  def sync_description
    "local"
  end

  def cleanup_needed?
    false
  end
end