KuberKit
  .define_configuration(:review)
  .use_registry(:review_default, as: :default)
  .use_artifact(:kuber_kit_repo, as: :kuber_kit_repo)
  .kubeconfig_path("/home/iskander/data/artstation_api/kuber_kit/clusters/prints_api_rke.yml")
  #.deployer_require_confirimation
  #.use_build_server(:remote_bs)