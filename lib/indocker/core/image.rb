class Indocker::Core::Image
  attr_reader :name, :dependencies, :registry, :dockerfile_path, :build_args, :build_context_dir, :tag, :before_build_callback, :after_build_callback

  Contract KeywordArgs[
    name:               Symbol,
    dependencies:       ArrayOf[Symbol],
    registry:           Maybe[Indocker::Infrastructure::Registry],
    dockerfile_path:    String,
    build_args:         Hash,
    build_context_dir:  Maybe[String],
    tag:                String,
    before_build_callback: Maybe[Proc],
    after_build_callback:  Maybe[Proc]
  ] => Any
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