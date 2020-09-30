class Indocker::Compiler::ImageDependencyResolver
  CircularDependencyError = Class.new(StandardError)
  DependencyNotFoundError = Class.new(StandardError)

  include Indocker::Import[
    "core.image_store"
  ]
  
  def get_next(image_name, resolved: [])
    ready_to_resolve = get_recursive_deps(image_name).select do |dep_name|
      unresolved_deps = get_deps(dep_name) - resolved
      unresolved_deps.empty?
    end
    ready_to_resolve - resolved
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

    (deps + child_deps).flatten.compact.uniq
  end

  def get_deps(image_name)
    image_store.get_definition(image_name).dependencies
  end
end