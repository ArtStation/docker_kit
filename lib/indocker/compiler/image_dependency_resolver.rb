class Indocker::Compiler::ImageDependencyResolver
  def get_next(image, all_definitions: {}, resolved: [])
    all_deps = get_recursive_deps(image, all_definitions: all_definitions)
    ready_to_resolve = all_deps.select do |image|
      image_deps = image.dependent_images || []
      image_deps.empty? || image_deps.all?{|i| resolved.map(&:image_name).include?(i) }
    end
    ready_to_resolve - resolved
  end

  def get_recursive_deps(image, all_definitions: {})
    deps = get_deps(image, all_definitions: all_definitions)

    deps += deps.map{ |i| get_recursive_deps(i, all_definitions: all_definitions) }.compact.flatten

    deps.uniq
  end

  def get_deps(image, all_definitions: {})
    (image.dependent_images || []).map do |image_name|
      dependent_image = all_definitions[image_name]
      raise "not found" if dependent_image.nil?
      dependent_image
    end
  end
end