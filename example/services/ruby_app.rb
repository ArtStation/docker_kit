KuberKit
  .define_service(:ruby_app)
  .template(:service)
  .images(:ruby_app)
  .tags("app")