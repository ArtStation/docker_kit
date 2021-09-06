class KuberKit::Defaults
  class << self
    def init
      return if @_initialized
      @_initialized = true
      init!
    end

    def init!
      KuberKit::Container["artifacts_sync.artifact_updater"].use_resolver(
        KuberKit::Container["artifacts_sync.git_artifact_resolver"], 
        artifact_class: KuberKit::Core::Artifacts::Git
      )
      KuberKit::Container["artifacts_sync.artifact_updater"].use_resolver(
        KuberKit::Container["artifacts_sync.null_artifact_resolver"], 
        artifact_class: KuberKit::Core::Artifacts::Local
      )
      KuberKit::Container["env_file_reader.reader"].use_reader(
        KuberKit::Container["env_file_reader.strategies.artifact_file"], 
        env_file_class: KuberKit::Core::EnvFiles::ArtifactFile
      )
      KuberKit::Container["env_file_reader.reader"].use_reader(
        KuberKit::Container["env_file_reader.strategies.env_group"], 
        env_file_class: KuberKit::Core::EnvFiles::EnvGroup
      )
      KuberKit::Container["template_reader.reader"].use_reader(
        KuberKit::Container["template_reader.strategies.artifact_file"], 
        template_class: KuberKit::Core::Templates::ArtifactFile
      )
    end
  end
end