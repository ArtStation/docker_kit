# Aliases for compatibility with old Indocker
module Indocker
  module Registries
    Local = Indocker::Core::Registries::Registry
    Remote = Indocker::Core::Registries::Registry
  end

  module Repositories
    NoSync = Indocker::Core::Artifacts::Local
    Git = Indocker::Core::Artifacts::Git
  end

  class << self
    def build_configuration(configuration_name)
      define_configuration(configuration_name)
    end
  end
end