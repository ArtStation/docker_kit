class KuberKit::Container
  extend Dry::Container::Mixin

  register "actions.image_compiler" do
    KuberKit::Actions::ImageCompiler.new
  end

  register "actions.env_file_reader" do
    KuberKit::Actions::EnvFileReader.new
  end

  register "actions.template_reader" do
    KuberKit::Actions::TemplateReader.new
  end

  register "actions.service_reader" do
    KuberKit::Actions::ServiceReader.new
  end

  register "actions.service_deployer" do
    KuberKit::Actions::ServiceDeployer.new
  end

  register "actions.configuration_loader" do
    KuberKit::Actions::ConfigurationLoader.new
  end

  register "actions.kubectl_applier" do
    KuberKit::Actions::KubectlApplier.new
  end

  register "configs" do
    KuberKit::Configs.new
  end

  register "core.image_factory" do
    KuberKit::Core::ImageFactory.new
  end
  
  register "core.image_definition_factory" do
    KuberKit::Core::ImageDefinitionFactory.new
  end

  register "core.image_store" do
    KuberKit::Core::ImageStore.new
  end

  register "core.service_factory" do
    KuberKit::Core::ServiceFactory.new
  end
  
  register "core.service_definition_factory" do
    KuberKit::Core::ServiceDefinitionFactory.new
  end

  register "core.service_store" do
    KuberKit::Core::ServiceStore.new
  end

  register "core.configuration_definition_factory" do
    KuberKit::Core::ConfigurationDefinitionFactory.new
  end

  register "core.configuration_factory" do
    KuberKit::Core::ConfigurationFactory.new
  end

  register "core.configuration_store" do
    KuberKit::Core::ConfigurationStore.new
  end

  register "core.registry_store" do
    KuberKit::Core::Registries::RegistryStore.new
  end

  register "core.artifact_store" do
    KuberKit::Core::Artifacts::ArtifactStore.new
  end

  register "core.env_file_store" do
    KuberKit::Core::EnvFiles::EnvFileStore.new
  end

  register "core.template_store" do
    KuberKit::Core::Templates::TemplateStore.new
  end

  register "core.context_helper_factory" do
    KuberKit::Core::ContextHelper::ContextHelperFactory.new
  end

  register "tools.file_presence_checker" do
    KuberKit::Tools::FilePresenceChecker.new
  end

  register "tools.logger_factory" do
    KuberKit::Tools::LoggerFactory.new
  end

  register "tools.logger" do
    KuberKit::Container["tools.logger_factory"].create("/tmp/kuber_kit.log")
  end

  register "shell.bash_commands" do
    KuberKit::Shell::BashCommands.new
  end

  register "shell.docker_commands" do
    KuberKit::Shell::DockerCommands.new
  end

  register "shell.git_commands" do
    KuberKit::Shell::GitCommands.new
  end

  register "shell.rsync_commands" do
    KuberKit::Shell::RsyncCommands.new
  end

  register "shell.kubectl_commands" do
    KuberKit::Shell::KubectlCommands.new
  end

  register "shell.local_shell" do
    KuberKit::Shell::LocalShell.new
  end

  register "shell.command_counter" do
    KuberKit::Shell::CommandCounter.new
  end

  register "preprocessing.text_preprocessor" do
    KuberKit::Preprocessing::TextPreprocessor.new
  end

  register "preprocessing.file_preprocessor" do
    KuberKit::Preprocessing::FilePreprocessor.new
  end

  register "preprocessing.dir_preprocessor" do
    KuberKit::Preprocessing::DirPreprocessor.new
  end

  register "image_compiler.compiler" do
    KuberKit::ImageCompiler::Compiler.new
  end

  register "image_compiler.image_builder" do
    KuberKit::ImageCompiler::ImageBuilder.new
  end

  register "image_compiler.image_build_dir_creator" do
    KuberKit::ImageCompiler::ImageBuildDirCreator.new
  end

  register "image_compiler.image_dependency_resolver" do
    KuberKit::ImageCompiler::ImageDependencyResolver.new
  end

  register "image_compiler.version_tag_builder" do
    KuberKit::ImageCompiler::VersionTagBuilder.new
  end

  register "artifacts_sync.artifacts_updater" do
    KuberKit::ArtifactsSync::ArtifactsUpdater.new
  end

  register "artifacts_sync.git_artifact_resolver" do
    KuberKit::ArtifactsSync::GitArtifactResolver.new
  end

  register "artifacts_sync.null_artifact_resolver" do
    KuberKit::ArtifactsSync::NullArtifactResolver.new
  end

  register "env_file_reader.action_handler" do
    KuberKit::EnvFileReader::ActionHandler.new
  end

  register "env_file_reader.reader" do
    KuberKit::EnvFileReader::Reader.new
  end

  register "env_file_reader.artifact_file_reader" do
    KuberKit::EnvFileReader::ArtifactFileReader.new
  end

  register "template_reader.reader" do
    KuberKit::TemplateReader::Reader.new
  end

  register "template_reader.artifact_file_reader" do
    KuberKit::TemplateReader::ArtifactFileReader.new
  end

  register "service_deployer.action_handler" do
    KuberKit::ServiceDeployer::ActionHandler.new
  end

  register "service_deployer.deployer" do
    KuberKit::ServiceDeployer::Deployer.new
  end

  register "service_deployer.service_reader" do
    KuberKit::ServiceDeployer::ServiceReader.new
  end

  register "service_deployer.service_list_resolver" do
    KuberKit::ServiceDeployer::ServiceListResolver.new
  end

  register "service_deployer.strategies.kubernetes" do
    KuberKit::ServiceDeployer::Strategies::Kubernetes.new
  end

  register "ui" do
    if KuberKit.debug_mode?
      KuberKit::UI::Simple.new
    else
      KuberKit::UI::Interactive.new
    end
  end
end