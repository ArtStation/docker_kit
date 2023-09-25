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

  register "actions.service_checker" do
    KuberKit::Actions::ServiceChecker.new
  end

  register "actions.configuration_loader" do
    KuberKit::Actions::ConfigurationLoader.new
  end

  register "actions.kubectl_applier" do
    KuberKit::Actions::KubectlApplier.new
  end

  register "actions.kubectl_attacher" do
    KuberKit::Actions::KubectlAttacher.new
  end

  register "actions.kubectl_console" do
    KuberKit::Actions::KubectlConsole.new
  end

  register "actions.kubectl_describe" do
    KuberKit::Actions::KubectlDescribe.new
  end

  register "actions.kubectl_get" do
    KuberKit::Actions::KubectlGet.new
  end

  register "actions.kubectl_logs" do
    KuberKit::Actions::KubectlLogs.new
  end

  register "actions.kubectl_env" do
    KuberKit::Actions::KubectlEnv.new
  end

  register "actions.shell_launcher" do
    KuberKit::Actions::ShellLauncher.new
  end

  register "configs" do
    KuberKit::Configs.new
  end

  register "core.artifact_path_resolver" do
    KuberKit::Core::ArtifactPathResolver.new
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

  register "core.artifact_store" do
    KuberKit::Core::Artifacts::ArtifactStore.new
  end

  register "core.build_server_store" do
    KuberKit::Core::BuildServers::BuildServerStore.new
  end

  register "core.env_file_store" do
    KuberKit::Core::EnvFiles::EnvFileStore.new
  end

  register "core.registry_store" do
    KuberKit::Core::Registries::RegistryStore.new
  end

  register "core.template_store" do
    KuberKit::Core::Templates::TemplateStore.new
  end

  register "core.context_helper_factory" do
    KuberKit::Core::ContextHelper::ContextHelperFactory.new
  end

  register "tools.build_dir_cleaner" do
    KuberKit::Tools::BuildDirCleaner.new
  end

  register "tools.file_presence_checker" do
    KuberKit::Tools::FilePresenceChecker.new
  end

  register "tools.logger_factory" do
    KuberKit::Tools::LoggerFactory.new
  end

  register "tools.logger" do
    KuberKit::Container["tools.logger_factory"].create()
  end

  register "tools.process_cleaner" do
    KuberKit::Tools::ProcessCleaner.new
  end

  register "tools.workdir_detector" do
    KuberKit::Tools::WorkdirDetector.new
  end

  register "shell.bash_commands" do
    KuberKit::Shell::Commands::BashCommands.new
  end

  register "shell.docker_commands" do
    KuberKit::Shell::Commands::DockerCommands.new
  end

  register "shell.docker_compose_commands" do
    KuberKit::Shell::Commands::DockerComposeCommands.new
  end

  register "shell.git_commands" do
    KuberKit::Shell::Commands::GitCommands.new
  end

  register "shell.rsync_commands" do
    KuberKit::Shell::Commands::RsyncCommands.new
  end

  register "shell.kubectl_commands" do
    KuberKit::Shell::Commands::KubectlCommands.new
  end

  register "shell.system_commands" do
    KuberKit::Shell::Commands::SystemCommands.new
  end

  register "shell.helm_commands" do
    KuberKit::Shell::Commands::HelmCommands.new
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

  register "image_compiler.action_handler" do
    KuberKit::ImageCompiler::ActionHandler.new
  end

  register "image_compiler.build_server_pool_factory" do
    KuberKit::ImageCompiler::BuildServerPoolFactory.new
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

  register "artifacts_sync.artifact_updater" do
    KuberKit::ArtifactsSync::ArtifactUpdater.new
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

  register "env_file_reader.env_file_parser" do
    KuberKit::EnvFileReader::EnvFileParser.new
  end

  register "env_file_reader.env_file_tempfile_creator" do
    KuberKit::EnvFileReader::EnvFileTempfileCreator.new
  end

  register "env_file_reader.strategies.artifact_file" do
    KuberKit::EnvFileReader::Strategies::ArtifactFile.new
  end

  register "env_file_reader.strategies.env_group" do
    KuberKit::EnvFileReader::Strategies::EnvGroup.new
  end

  register "template_reader.action_handler" do
    KuberKit::TemplateReader::ActionHandler.new
  end

  register "template_reader.reader" do
    KuberKit::TemplateReader::Reader.new
  end

  register "template_reader.strategies.artifact_file" do
    KuberKit::TemplateReader::Strategies::ArtifactFile.new
  end

  register "service_deployer.action_handler" do
    KuberKit::ServiceDeployer::ActionHandler.new
  end

  register "service_deployer.strategy_detector" do
    KuberKit::ServiceDeployer::StrategyDetector.new
  end

  register "service_deployer.deployer" do
    KuberKit::ServiceDeployer::Deployer.new
  end

  register "service_deployer.deployment_options_selector" do
    KuberKit::ServiceDeployer::DeploymentOptionsSelector.new
  end

  register "service_deployer.service_list_resolver" do
    KuberKit::ServiceDeployer::ServiceListResolver.new
  end

  register "service_deployer.service_dependency_resolver" do
    KuberKit::ServiceDeployer::ServiceDependencyResolver.new
  end

  register "service_generator.action_handler" do
    KuberKit::ServiceGenerator::ActionHandler.new
  end

  register "service_generator.strategy_detector" do
    KuberKit::ServiceGenerator::StrategyDetector.new
  end

  register "service_generator.generator" do
    KuberKit::ServiceGenerator::Generator.new
  end

  register "service_reader.action_handler" do
    KuberKit::ServiceReader::ActionHandler.new
  end

  register "service_reader.reader" do
    KuberKit::ServiceReader::Reader.new
  end

  register "shell_launcher.action_handler" do
    KuberKit::ShellLauncher::ActionHandler.new
  end

  register "shell_launcher.launcher" do
    KuberKit::ShellLauncher::Launcher.new
  end

  register "kubernetes.resource_selector" do
    KuberKit::Kubernetes::ResourceSelector.new
  end

  register "kubernetes.resources_fetcher" do
    KuberKit::Kubernetes::ResourcesFetcher.new
  end

  register "ui" do
    if KuberKit.ui_mode == :debug
      KuberKit::UI::Debug.new
    elsif KuberKit.ui_mode == :simple
      KuberKit::UI::Simple.new
    elsif KuberKit.ui_mode == :api
      KuberKit::UI::Api.new
    else
      KuberKit::UI::Interactive.new
    end
  end
end