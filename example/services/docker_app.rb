KuberKit
  .define_service(:docker_app)
  .images(:ruby_app)
  .deployer_strategy(:docker)
  .attributes(
    deployer: {
      detached:         false,
      image_name:       :ruby_app,
      container_name:   "test_docker_app",
      delete_if_exists: true
    }
  )