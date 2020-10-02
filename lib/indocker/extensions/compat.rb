# Aliases for compatibility with old Indocker
module Indocker
  module Registries
    Abstract = Indocker::Core::Registry
    Local = Indocker::Core::Registry
    Remote = Indocker::Core::Registry
  end

  class << self
    def build_configuration(configuration_name)
      define_configuration(configuration_name)
    end
  end
end