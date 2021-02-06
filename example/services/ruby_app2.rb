KuberKit
  .define_service(:ruby_app2)
  .template(:service)
  .images(:ruby_app2)
  .tags("app")