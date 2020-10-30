DockerKit
  .define_image(:ruby_app2)
  .registry(:default)
  .depends_on(:ruby, :app_sources)