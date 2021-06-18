KuberKit
  .define_service(:failing_app)
  .depends_on(:env_file)
  .template(:service)
  .images(:failing_app)
  .tags("app", "minimal")