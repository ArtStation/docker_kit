DockerKit
  .define_configuration(:review)
  .use_registry(:review_default, as: :default)
  .use_artifact(:docker_kit_repo, as: :docker_kit_repo)