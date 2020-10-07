# Aliases for compatibility with old Indocker
module Indocker
  module Registries
    Local = Indocker::Core::Registries::Registry
    Remote = Indocker::Core::Registries::Registry
  end

  module Repositories
    NoSync = Indocker::Core::Repositories::Local
    Git = Indocker::Core::Repositories::Git
  end

  class << self
    def build_configuration(configuration_name)
      define_configuration(configuration_name)
    end
  end
end