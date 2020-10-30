class DockerKit::ImageCompiler::VersionTagBuilder
  def get_version
    Time.now.strftime("%Y%m%d.%H%M%S")
  end
end