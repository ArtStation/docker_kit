class DockerKit::Container
  extend Dry::Container::Mixin

  register "actions.image_compiler" do
    DockerKit::Actions::ImageCompiler.new
  end

  register "actions.env_file_reader" do
    DockerKit::Actions::EnvFileReader.new
  end

  register "actions.template_reader" do
    DockerKit::Actions::TemplateReader.new
  end

  register "actions.service_reader" do
    DockerKit::Actions::ServiceReader.new
  end

  register "actions.service_applier" do
    DockerKit::Actions::ServiceApplier.new
  end

  register "actions.configuration_loader" do
    DockerKit::Actions::ConfigurationLoader.new
  end

  register "actions.kubectl_applier" do
    DockerKit::Actions::KubectlApplier.new
  end

  register "configs" do
    DockerKit::Configs.new
  end

  register "core.image_factory" do
    DockerKit::Core::ImageFactory.new
  end
  
  register "core.image_definition_factory" do
    DockerKit::Core::ImageDefinitionFactory.new
  end

  register "core.image_store" do
    DockerKit::Core::ImageStore.new
  end

  register "core.service_factory" do
    DockerKit::Core::ServiceFactory.new
  end
  
  register "core.service_definition_factory" do
    DockerKit::Core::ServiceDefinitionFactory.new
  end

  register "core.service_store" do
    DockerKit::Core::ServiceStore.new
  end

  register "core.configuration_definition_factory" do
    DockerKit::Core::ConfigurationDefinitionFactory.new
  end

  register "core.configuration_factory" do
    DockerKit::Core::ConfigurationFactory.new
  end

  register "core.configuration_store" do
    DockerKit::Core::ConfigurationStore.new
  end

  register "core.registry_store" do
    DockerKit::Core::Registries::RegistryStore.new
  end

  register "core.artifact_store" do
    DockerKit::Core::Artifacts::ArtifactStore.new
  end

  register "core.env_file_store" do
    DockerKit::Core::EnvFiles::EnvFileStore.new
  end

  register "core.template_store" do
    DockerKit::Core::Templates::TemplateStore.new
  end

  register "core.context_helper_factory" do
    DockerKit::Core::ContextHelper::ContextHelperFactory.new
  end

  register "tools.file_presence_checker" do
    DockerKit::Tools::FilePresenceChecker.new
  end

  register "tools.logger_factory" do
    DockerKit::Tools::LoggerFactory.new
  end

  register "tools.logger" do
    DockerKit::Container["tools.logger_factory"].create("/tmp/docker_kit.log")
  end

  register "shell.bash_commands" do
    DockerKit::Shell::BashCommands.new
  end

  register "shell.docker_commands" do
    DockerKit::Shell::DockerCommands.new
  end

  register "shell.git_commands" do
    DockerKit::Shell::GitCommands.new
  end

  register "shell.rsync_commands" do
    DockerKit::Shell::RsyncCommands.new
  end

  register "shell.kubectl_commands" do
    DockerKit::Shell::KubectlCommands.new
  end

  register "shell.local_shell" do
    DockerKit::Shell::LocalShell.new
  end

  register "shell.command_counter" do
    DockerKit::Shell::CommandCounter.new
  end

  register "preprocessing.text_preprocessor" do
    DockerKit::Preprocessing::TextPreprocessor.new
  end

  register "preprocessing.file_preprocessor" do
    DockerKit::Preprocessing::FilePreprocessor.new
  end

  register "preprocessing.dir_preprocessor" do
    DockerKit::Preprocessing::DirPreprocessor.new
  end

  register "image_compiler.compiler" do
    DockerKit::ImageCompiler::Compiler.new
  end

  register "image_compiler.image_builder" do
    DockerKit::ImageCompiler::ImageBuilder.new
  end

  register "image_compiler.image_build_dir_creator" do
    DockerKit::ImageCompiler::ImageBuildDirCreator.new
  end

  register "image_compiler.image_dependency_resolver" do
    DockerKit::ImageCompiler::ImageDependencyResolver.new
  end

  register "image_compiler.version_tag_builder" do
    DockerKit::ImageCompiler::VersionTagBuilder.new
  end

  register "artifacts_sync.artifacts_updater" do
    DockerKit::ArtifactsSync::ArtifactsUpdater.new
  end

  register "artifacts_sync.git_artifact_resolver" do
    DockerKit::ArtifactsSync::GitArtifactResolver.new
  end

  register "artifacts_sync.null_artifact_resolver" do
    DockerKit::ArtifactsSync::NullArtifactResolver.new
  end

  register "env_file_reader.reader" do
    DockerKit::EnvFileReader::Reader.new
  end

  register "env_file_reader.artifact_file_reader" do
    DockerKit::EnvFileReader::ArtifactFileReader.new
  end

  register "template_reader.reader" do
    DockerKit::TemplateReader::Reader.new
  end

  register "template_reader.artifact_file_reader" do
    DockerKit::TemplateReader::ArtifactFileReader.new
  end

  register "service_deployer.service_reader" do
    DockerKit::ServiceDeployer::ServiceReader.new
  end

  register "service_deployer.service_list_resolver" do
    DockerKit::ServiceDeployer::ServiceListResolver.new
  end

  register "ui" do
    if DockerKit.debug_mode?
      DockerKit::UI::Simple.new
    else
      DockerKit::UI::Interactive.new
    end
  end
end