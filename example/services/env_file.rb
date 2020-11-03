KuberKit
  .define_service(:env_file)
  .template(:env_file)
  .attributes(
    deployment_restart_enabled: false
  )