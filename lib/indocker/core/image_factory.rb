class Indocker::Core::ImageFactory
  CircularDependencyError = Class.new(StandardError)
  DependencyNotFoundError = Class.new(StandardError)

  include Indocker::Import["configs"]
  include Indocker::Import["tools.file_presence_checker"]

  def create(definition, all_definitions: {}, dependency_tree: [])
    image_attrs = definition.to_image_attrs

    dependent_images = create_dependent_images(
      image_attrs, 
      all_definitions: all_definitions,
      dependency_tree: dependency_tree,
    )

    dockerfile_path = image_attrs.dockerfile_path || File.join(image_attrs.dir, configs.image_dockerfile_name)
    file_presence_checker.check_file!(dockerfile_path)

    if image_attrs.build_context_dir
      file_presence_checker.check_dir!(image_attrs.build_context_dir)
      build_context_dir = image_attrs.build_context_dir
    else
      default_dir = File.join(image_attrs.dir, configs.image_build_context_dir)
      build_context_dir = file_presence_checker.dir_exists?(default_dir) ? default_dir : nil
    end

    Indocker::Core::Image.new(
      name:                   image_attrs.name,
      dependent_images:       dependent_images,
      registry_name:          image_attrs.registry_name,
      dockerfile_path:        dockerfile_path,
      build_args:             image_attrs.build_args || {},
      build_context_dir:      build_context_dir,
      tag:                    image_attrs.tag || configs.image_tag,
      before_build_callback:  image_attrs.before_build_callback,
      after_build_callback:   image_attrs.after_build_callback
    )
  end

  def create_dependent_images(image_attrs, all_definitions:, dependency_tree:)
    if dependency_tree.include?(image_attrs.name)
      raise CircularDependencyError, "Circular dependency found while creating #{image_attrs.name}. Dependency tree: #{dependency_tree.inspect}"
    end

    dependent_images = image_attrs.dependent_images || []
    dependent_images.map do |dependency_name|
      dependency = all_definitions[dependency_name]
      if dependency.nil?
        raise DependencyNotFoundError, "Dependent image not found: #{dependency_name}"
      end

      create(
        dependency, 
        all_definitions: all_definitions,
        dependency_tree: dependency_tree + [image_attrs.name]
      )
    end
  end
end