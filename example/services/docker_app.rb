KuberKit
  .define_service(:docker_app)
  .images(:ruby_app)
  .deployer_strategy(:docker)
  .attributes do
    artifact_store = KuberKit::Core::Artifacts::ArtifactStore.new
    artifact  = artifact_store.get(:kuber_kit_repo)
    root_path = artifact.cloned_path

    {
      deployer: {
        detached:         false,
        container_name:   "test_docker_app",
        image_name:       :ruby_app,
        networks:         ["test_network"],
        volumes:          ["#{root_path}:/app"],
        delete_if_exists: true
      }
    }
  end