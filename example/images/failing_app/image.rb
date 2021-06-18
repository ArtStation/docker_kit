KuberKit
  .define_image(:failing_app)
  .registry(:default)
  .depends_on(:ruby, :app_sources)