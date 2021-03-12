class KuberKit::Core::Image
  attr_reader :name, :dependencies, :registry, :dockerfile_path, :build_vars, :build_context_dir, :tag, 
              :before_build_callback, :after_build_callback

  Contract KeywordArgs[
    name:               Symbol,
    dependencies:       ArrayOf[Symbol],
    registry:           Maybe[KuberKit::Core::Registries::Registry],
    dockerfile_path:    String,
    build_vars:         Hash,
    build_context_dir:  Maybe[String],
    tag:                String,
    before_build_callback: Maybe[Proc],
    after_build_callback:  Maybe[Proc]
  ] => Any
  def initialize(name:, dependencies:, registry:, dockerfile_path:, build_vars:, build_context_dir:, tag:, before_build_callback:, after_build_callback:)
    @name = name
    @dependencies = dependencies
    @registry = registry
    @dockerfile_path = dockerfile_path
    @build_vars = build_vars
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

  def build_args
    unless KuberKit.deprecation_warnings_disabled?
      puts "WARNING: build_args is deprecated, please use build_vars instead"
    end
    build_vars
  end
end