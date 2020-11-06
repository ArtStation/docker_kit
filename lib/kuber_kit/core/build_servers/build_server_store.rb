class KuberKit::Core::BuildServers::BuildServerStore
  def add(build_server)
    store.add(build_server.name, build_server)
  end

  def get(build_server_name)
    store.get(build_server_name)
  end

  def reset!
    store.reset!
  end

  private
    def store
      @@store ||= KuberKit::Core::Store.new(KuberKit::Core::BuildServers::AbstractBuildServer)
    end
end