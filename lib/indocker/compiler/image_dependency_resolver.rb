class Indocker::Compiler::ImageDependencyResolver
  CircularDependencyError = Class.new(StandardError)
  DependencyNotFoundError = Class.new(StandardError)

  include Indocker::Import[
    "core.image_store"
  ]
  
  def get_next(image, resolved: [])
    all_deps = get_recursive_deps(image)
    ready_to_resolve = all_deps.select do |image|
      image_deps = image.dependent_images || []
      image_deps.empty? || image_deps.all?{|i| resolved.map(&:image_name).include?(i) }
    end
    ready_to_resolve - resolved
  end

  def get_recursive_deps(image, dependency_tree: [])
    deps = get_deps(image)

    if dependency_tree.include?(image.image_name)
      raise CircularDependencyError, "Circular dependency found for #{image.image_name}. Dependency tree: #{dependency_tree.inspect}"
    end

    child_deps = []
    deps.each do |i| 
      child_deps += get_recursive_deps(i, dependency_tree: dependency_tree + [image.image_name])
    end

    (deps + child_deps).flatten.compact.uniq
  end

  def get_deps(image)
    (image.dependent_images || []).map do |image_name|
      image_store.get_definition(image_name)
    end
  end
end