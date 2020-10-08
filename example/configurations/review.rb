Indocker
  .define_configuration(:review)
  .use_registry(:review_default, as: :default)
  .use_artifact(:indocker_repo, as: :indocker_repo)