KuberKit
  .define_configuration(:review)
  .use_registry(:review_default, as: :default)
  .use_artifact(:kuber_kit_repo, as: :kuber_kit_repo)