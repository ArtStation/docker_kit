class Indocker::Container
  extend Dry::Container::Mixin

  register "actions.image_compiler" do
    Indocker::Actions::ImageCompiler.new
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

  register "core.infra_store" do
    Indocker::Core::InfraStore.new
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

  register "shell.local_shell" do
    Indocker::Shell::LocalShell.new
  end

  register "compiler.template_compiler" do
    Indocker::Compiler::TemplateCompiler.new
  end

  register "compiler.template_file_compiler" do
    Indocker::Compiler::TemplateFileCompiler.new
  end

  register "compiler.template_dir_compiler" do
    Indocker::Compiler::TemplateDirCompiler.new
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

  register "ui" do
    Indocker::UI.new
  end
end