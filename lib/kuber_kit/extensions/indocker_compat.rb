# Aliases for compatibility with Indocker
module KuberKit
  module Registries
    Local = KuberKit::Core::Registries::Registry
    Remote = KuberKit::Core::Registries::Registry
  end

  module Repositories
    NoSync = KuberKit::Core::Artifacts::Local
    Git = KuberKit::Core::Artifacts::Git
  end

  class << self
    def build_configuration(configuration_name)
      define_configuration(configuration_name)
    end
  end
end
Indocker = KuberKit