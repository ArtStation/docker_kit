class Indocker::Core::Image
  attr_reader :name, :dependencies, :registry, :dockerfile_path, :build_args, :build_context_dir, :tag, :before_build_callback, :after_build_callback

  def initialize(name:, dependencies:, registry:, dockerfile_path:, build_args:, build_context_dir:, tag:, before_build_callback:, after_build_callback:)
    @name = name
    @dependencies = dependencies
    @registry = registry
    @dockerfile_path = dockerfile_path
    @build_args = build_args
    @build_context_dir = build_context_dir
    @tag = tag
    @before_build_callback = before_build_callback
    @after_build_callback = after_build_callback
  end

  def registry_url
    "#{registry.path}/#{name}:#{tag}"
  end

  def remote_registry_url
    "#{registry.remote_path}/#{name}:#{tag}"
  end
end