class Indocker::Core::ImageFactory
  def create(definition)
    image_attrs = definition.to_image_attrs

    Indocker::Core::Image.new(
      name:                   image_attrs.name,
      dependent_images:       image_attrs.dependent_images,
      registry_name:          image_attrs.registry_name,
      dockerfile_path:        image_attrs.dockerfile_path,
      build_args:             image_attrs.build_args,
      build_context_dir:      image_attrs.build_context_dir,
      tag:                    image_attrs.tag,
      before_build_callback:  image_attrs.before_build_callback,
      after_build_callback:   image_attrs.after_build_callback
    )
  end
end