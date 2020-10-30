class DockerKit::Core::ImageFactory
  include DockerKit::Import[
    "configs",
    "tools.file_presence_checker",
    "core.registry_store"
  ]

  def create(definition)
    image_attrs = definition.to_image_attrs

    dockerfile_path = image_attrs.dockerfile_path || File.join(image_attrs.dir, configs.image_dockerfile_name)
    file_presence_checker.check_file!(dockerfile_path)

    if image_attrs.build_context_dir
      file_presence_checker.check_dir!(image_attrs.build_context_dir)
      build_context_dir = image_attrs.build_context_dir
    else
      default_dir = File.join(image_attrs.dir, configs.image_build_context_dir)
      build_context_dir = file_presence_checker.dir_exists?(default_dir) ? default_dir : nil
    end

    if image_attrs.registry_name
      registry = registry_store.get(image_attrs.registry_name)
    else
      registry = registry_store.default_registry
    end

    DockerKit::Core::Image.new(
      name:                   image_attrs.name,
      dependencies:           image_attrs.dependencies,
      registry:               registry,
      dockerfile_path:        dockerfile_path,
      build_vars:             image_attrs.build_vars || {},
      build_context_dir:      build_context_dir,
      tag:                    image_attrs.tag || configs.image_tag,
      before_build_callback:  image_attrs.before_build_callback,
      after_build_callback:   image_attrs.after_build_callback
    )
  end
end