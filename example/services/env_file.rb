KuberKit
  .define_service(:env_file)
  .template(:env_file)
  .tags("env_file")
  .attributes(
    deployer_restart_enabled: false
  )