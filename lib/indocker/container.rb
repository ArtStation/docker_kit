class Indocker::Container
  extend Dry::Container::Mixin

  register "actions.image_compiler" do
    Indocker::Actions::ImageCompiler.new
  end

  register "actions.env_file_reader" do
    Indocker::Actions::EnvFileReader.new
  end

  register "actions.template_reader" do
    Indocker::Actions::TemplateReader.new
  end

  register "actions.configuration_loader" do
    Indocker::Actions::ConfigurationLoader.new
  end

  register "configs" do
    Indocker::Configs.new
  end

  register "core.image_factory" do
    Indocker::Core::ImageFactory.new
  end
  
  register "core.image_definition_factory" do
    Indocker::Core::ImageDefinitionFactory.new
  end

  register "core.image_store" do
    Indocker::Core::ImageStore.new
  end

  register "core.service_factory" do
    Indocker::Core::ServiceFactory.new
  end
  
  register "core.service_definition_factory" do
    Indocker::Core::ServiceDefinitionFactory.new
  end

  register "core.service_store" do
    Indocker::Core::ServiceStore.new
  end

  register "core.configuration_definition_factory" do
    Indocker::Core::ConfigurationDefinitionFactory.new
  end

  register "core.configuration_factory" do
    Indocker::Core::ConfigurationFactory.new
  end

  register "core.configuration_store" do
    Indocker::Core::ConfigurationStore.new
  end

  register "core.registry_store" do
    Indocker::Core::Registries::RegistryStore.new
  end

  register "core.artifact_store" do
    Indocker::Core::Artifacts::ArtifactStore.new
  end

  register "core.env_file_store" do
    Indocker::Core::EnvFiles::EnvFileStore.new
  end

  register "core.template_store" do
    Indocker::Core::Templates::TemplateStore.new
  end

  register "core.context_helper_factory" do
    Indocker::Core::ContextHelperFactory.new
  end

  register "tools.file_presence_checker" do
    Indocker::Tools::FilePresenceChecker.new
  end

  register "tools.logger_factory" do
    Indocker::Tools::LoggerFactory.new
  end

  register "tools.logger" do
    Indocker::Container["tools.logger_factory"].create("/tmp/indocker.log")
  end

  register "shell.bash_commands" do
    Indocker::Shell::BashCommands.new
  end

  register "shell.docker_commands" do
    Indocker::Shell::DockerCommands.new
  end

  register "shell.git_commands" do
    Indocker::Shell::GitCommands.new
  end

  register "shell.rsync_commands" do
    Indocker::Shell::RsyncCommands.new
  end

  register "shell.local_shell" do
    Indocker::Shell::LocalShell.new
  end

  register "shell.command_counter" do
    Indocker::Shell::CommandCounter.new
  end

  register "preprocessing.text_preprocessor" do
    Indocker::Preprocessing::TextPreprocessor.new
  end

  register "preprocessing.file_preprocessor" do
    Indocker::Preprocessing::FilePreprocessor.new
  end

  register "preprocessing.dir_preprocessor" do
    Indocker::Preprocessing::DirPreprocessor.new
  end

  register "image_compiler.compiler" do
    Indocker::ImageCompiler::Compiler.new
  end

  register "image_compiler.image_builder" do
    Indocker::ImageCompiler::ImageBuilder.new
  end

  register "image_compiler.image_build_dir_creator" do
    Indocker::ImageCompiler::ImageBuildDirCreator.new
  end

  register "image_compiler.image_dependency_resolver" do
    Indocker::ImageCompiler::ImageDependencyResolver.new
  end

  register "image_compiler.version_tag_builder" do
    Indocker::ImageCompiler::VersionTagBuilder.new
  end

  register "artifacts_sync.artifacts_updater" do
    Indocker::ArtifactsSync::ArtifactsUpdater.new
  end

  register "artifacts_sync.git_artifact_resolver" do
    Indocker::ArtifactsSync::GitArtifactResolver.new
  end

  register "artifacts_sync.null_artifact_resolver" do
    Indocker::ArtifactsSync::NullArtifactResolver.new
  end

  register "env_file_reader.reader" do
    Indocker::EnvFileReader::Reader.new
  end

  register "env_file_reader.artifact_file_reader" do
    Indocker::EnvFileReader::ArtifactFileReader.new
  end

  register "template_reader.reader" do
    Indocker::TemplateReader::Reader.new
  end

  register "template_reader.artifact_file_reader" do
    Indocker::TemplateReader::ArtifactFileReader.new
  end

  register "ui" do
    if Indocker.debug_mode?
      Indocker::UI::Simple.new
    else
      Indocker::UI::Interactive.new
    end
  end
end