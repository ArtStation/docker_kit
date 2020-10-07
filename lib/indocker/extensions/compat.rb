# Aliases for compatibility with old Indocker
module Indocker
  module Registries
    Abstract = Indocker::Core::Registries::Registry
    Local = Indocker::Core::Registries::Registry
    Remote = Indocker::Core::Registries::Registry
  end

  class << self
    def build_configuration(configuration_name)
      define_configuration(configuration_name)
    end
  end
end