class Indocker::Container
  extend Dry::Container::Mixin

  register "actions.image_compiler" do
    Indocker::Actions::ImageCompiler.new
  end

  register "actions.env_file_reader" do
    Indocker::Actions::EnvFileReader.new
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

  register "compiler.image_builder" do
    Indocker::Compiler::ImageBuilder.new
  end

  register "compiler.image_build_dir_creator" do
    Indocker::Compiler::ImageBuildDirCreator.new
  end

  register "compiler.image_compiler" do
    Indocker::Compiler::ImageCompiler.new
  end

  register "compiler.image_dependency_resolver" do
    Indocker::Compiler::ImageDependencyResolver.new
  end

  register "compiler.context_helper_factory" do
    Indocker::Compiler::ContextHelperFactory.new
  end

  register "compiler.version_tag_builder" do
    Indocker::Compiler::VersionTagBuilder.new
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

  register "ui" do
    if Indocker.debug_mode?
      Indocker::UI::Simple.new
    else
      Indocker::UI::Interactive.new
    end
  end
end