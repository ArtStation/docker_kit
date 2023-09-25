class KuberKit::Defaults
  class << self
    def init
      return if @_initialized
      @_initialized = true
      init!
    end

    def init!
      container["artifacts_sync.artifact_updater"].use_resolver(
        container["artifacts_sync.git_artifact_resolver"], 
        artifact_class: KuberKit::Core::Artifacts::Git
      )
      container["artifacts_sync.artifact_updater"].use_resolver(
        container["artifacts_sync.null_artifact_resolver"], 
        artifact_class: KuberKit::Core::Artifacts::Local
      )
      container["env_file_reader.reader"].use_reader(
        container["env_file_reader.strategies.artifact_file"], 
        env_file_class: KuberKit::Core::EnvFiles::ArtifactFile
      )
      container["env_file_reader.reader"].use_reader(
        container["env_file_reader.strategies.env_group"], 
        env_file_class: KuberKit::Core::EnvFiles::EnvGroup
      )
      container["template_reader.reader"].use_reader(
        container["template_reader.strategies.artifact_file"], 
        template_class: KuberKit::Core::Templates::ArtifactFile
      )
      container["service_deployer.deployer"].register_strategy(
        :kubernetes,
        KuberKit::ServiceDeployer::Strategies::Kubernetes.new
      )
      container["service_deployer.deployer"].register_strategy(
        :docker,
        KuberKit::ServiceDeployer::Strategies::Docker.new
      )
      container["service_deployer.deployer"].register_strategy(
        :docker_compose,
        KuberKit::ServiceDeployer::Strategies::DockerCompose.new
      )
      container["service_deployer.deployer"].register_strategy(
        :helm,
        KuberKit::ServiceDeployer::Strategies::Helm.new
      )

      container["service_generator.generator"].register_strategy(
        :helm,
        KuberKit::ServiceGenerator::Strategies::Helm.new
      )

      container["shell_launcher.launcher"].register_strategy(
        :kubernetes,
        KuberKit::ShellLauncher::Strategies::Kubernetes.new
      )
    end

    private
      def container
        KuberKit::Container
      end
  end
end