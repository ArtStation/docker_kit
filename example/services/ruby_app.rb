KuberKit
  .define_service(:ruby_app)
  .depends_on(:env_file)
  .template(:service)
  .images(:ruby_app)
  .tags("app")