class KuberKit::ImageCompiler::ImageDependencyResolver
  CircularDependencyError = Class.new(KuberKit::Error)
  DependencyNotFoundError = Class.new(KuberKit::NotFoundError)

  include KuberKit::Import[
    "core.image_store"
  ]
  
  Contract Any, KeywordArgs[
    resolved: Optional[ArrayOf[Symbol]],
    limit:    Optional[Maybe[Num]]
  ] => Any
  def get_next(image_names, resolved: [], limit: nil)
    deps = Array(image_names).map { |i| get_recursive_deps(i) }.flatten.uniq

    ready_to_resolve = deps.select do |dep_name|
      unresolved_deps = get_deps(dep_name) - resolved
      unresolved_deps.empty?
    end
    unresolved_deps = ready_to_resolve - resolved
    unresolved_deps = unresolved_deps.take(limit) if limit
    unresolved_deps
  end

  def get_recursive_deps(image_name, dependency_tree: [])
    deps = get_deps(image_name)

    if dependency_tree.include?(image_name)
      raise CircularDependencyError, "Circular dependency found for #{image_name}. Dependency tree: #{dependency_tree.inspect}"
    end

    child_deps = []
    deps.each do |i| 
      child_deps += get_recursive_deps(i, dependency_tree: dependency_tree + [image_name])
    end

    (deps + child_deps).uniq
  end

  def get_deps(image_name)
    image_store.get_definition(image_name).dependencies
  end
end