KuberKit
  .define_service(:auth_app)
  .template(:docker_compose)
  .images(:ruby_app)
  .tags(:compose)
  .deployer_strategy(:docker_compose)
  .attributes(
    image_name: :ruby_app,
    deployer_interactive: true
  )