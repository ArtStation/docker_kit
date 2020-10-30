class TestHelper
  class HelloWorldContextHelper
    def hello_world
      "hello world"
    end

    def configuration_name
      :default
    end
  
    def get_binding
      binding
    end
  end

  def shell
    TestShell.new
  end

  def context_helper
    HelloWorldContextHelper.new
  end

  def image_store
    KuberKit::Container['core.image_store']
  end

  def service_store
    KuberKit::Container['core.service_store']
  end

  def artifact_store
    KuberKit::Container['core.artifact_store']
  end

  def registry_store
    KuberKit::Container['core.registry_store']
  end

  def env_file_store
    KuberKit::Container['core.env_file_store']
  end

  def template_store
    KuberKit::Container['core.template_store']
  end
  
  def image_factory
    KuberKit::Container['core.image_factory']
  end

  def image_definition_factory
    KuberKit::Container['core.image_definition_factory']
  end
  
  def image_definition(name)
    image_definition_factory.create(name)
  end
  
  def image(name)
    definition = image_definition(name)
    image_factory.create(definition)
  end

  def remote_image(name, url)
    add_registry(:remote, url)
    remote_image_def = image_definition(:remote_image).registry(:remote)
    remote_image = image_factory.create(remote_image_def)
  end

  def service_definition_factory
    KuberKit::Container['core.service_definition_factory']
  end

  def service_factory
    KuberKit::Container['core.service_factory']
  end

  def service_definition(name)
    service_definition_factory.create(name)
  end

  def configuration_store
    KuberKit::Container['core.configuration_store']
  end

  def configuration_definition_factory
    KuberKit::Container['core.configuration_definition_factory']
  end

  def configuration_definition(name)
    configuration_definition_factory.create(name)
  end

  def add_registry(name, url)
    registry = KuberKit::Core::Registries::Registry.new(name).set_remote_url(url)
    registry_store.add(registry)
  end

  def add_artifact(name, url)
    artifact = KuberKit::Core::Artifacts::Git.new(name).setup(remote_url: url)
    artifact_store.add(artifact)
  end
end