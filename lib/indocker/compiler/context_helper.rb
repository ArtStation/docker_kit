class Indocker::Compiler::ContextHelper
  attr_reader :shell

  def initialize(image_store:, artifact_store:, shell:)
    @image_store    = image_store
    @artifact_store = artifact_store
    @shell          = shell
  end

  def image_url(image_name)
    image = @image_store.get_image(image_name)

    image.remote_registry_url
  end

  def artifact_path(name, file_name = nil)
    artifact = @artifact_store.get(name)
    [artifact.cloned_path, file_name].compact.join("/")
  end

  def get_binding
    binding
  end

  # RDM helpers
  # TODO - move to somewhere else
  def package_path(repo_name, package_name)
    @package_paths ||= {}

    if @package_paths[repo_name] && @package_paths[repo_name][package_name]
      return @package_paths[repo_name][package_name]
    end

    rdm_packages = rdm_packages_content(repo_name)
    package_path = nil

    rdm_packages.each_line do |line|
      next if !line.include?('package')
      next if !line.include?("/#{package_name}'")

      path = line.split(' ').last.gsub("'", '').gsub("\"", '')
      package_path = File.join('/app', path)
      break
    end

    if package_path.nil?
      raise ArgumentError.new("path not found for package :#{package_name} in repository :#{repo_name}")
    end

    @package_paths[repo_name] ||= {}
    @package_paths[repo_name][package_name] = package_path
    package_path
  end

  def rdm_packages_content(artifact_name)
    artifact = @artifact_store.get(artifact_name)

    File
      .read(File.join(artifact.cloned_path, 'Rdm.packages'))
      .gsub("\"", "'")
  end
end