class KuberKit::ImageCompiler::ImageDependencyResolver < KuberKit::Core::Dependencies::AbstractDependencyResolver
  include KuberKit::Import[
    "core.image_store",
    "configs"
  ]
  
  def get_deps(image_name)
    image_store.get_definition(image_name).dependencies
  end

  def dependency_batch_size
    configs.compile_simultaneous_limit
  end
end