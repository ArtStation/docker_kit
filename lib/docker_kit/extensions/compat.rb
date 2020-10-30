# Aliases for compatibility with old DockerKit
module DockerKit
  module Registries
    Local = DockerKit::Core::Registries::Registry
    Remote = DockerKit::Core::Registries::Registry
  end

  module Repositories
    NoSync = DockerKit::Core::Artifacts::Local
    Git = DockerKit::Core::Artifacts::Git
  end

  class << self
    def build_configuration(configuration_name)
      define_configuration(configuration_name)
    end
  end
end