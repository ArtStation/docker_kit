class Indocker::Compiler::ImageDependencyResolver
  CircularDependencyError = Class.new(StandardError)
  DependencyNotFoundError = Class.new(StandardError)
  
  def get_next(image, all_definitions: {}, resolved: [])
    all_deps = get_recursive_deps(image, all_definitions: all_definitions)
    ready_to_resolve = all_deps.select do |image|
      image_deps = image.dependent_images || []
      image_deps.empty? || image_deps.all?{|i| resolved.map(&:image_name).include?(i) }
    end
    ready_to_resolve - resolved
  end

  def get_recursive_deps(image, all_definitions: {}, dependency_tree: [])
    deps = get_deps(image, all_definitions: all_definitions)

    if dependency_tree.include?(image.image_name)
      raise CircularDependencyError, "Circular dependency found for #{image.image_name}. Dependency tree: #{dependency_tree.inspect}"
    end

    child_deps = []
    deps.each do |i| 
      child_deps += get_recursive_deps(i, all_definitions: all_definitions, dependency_tree: dependency_tree + [image.image_name])
    end

    (deps + child_deps).flatten.compact.uniq
  end

  def get_deps(image, all_definitions: {})
    (image.dependent_images || []).map do |image_name|
      dependent_image = all_definitions[image_name]
      if dependent_image.nil?
        raise DependencyNotFoundError, "Dependent image not found: #{image_name}"
      end
      raise "not found" if dependent_image.nil?
      dependent_image
    end
  end
end