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
    Indocker::Container['core.image_store']
  end

  def artifact_store
    Indocker::Container['core.artifact_store']
  end

  def registry_store
    Indocker::Container['core.registry_store']
  end

  def env_file_store
    Indocker::Container['core.env_file_store']
  end

  def template_store
    Indocker::Container['core.template_store']
  end
  
  def image_factory
    Indocker::Container['core.image_factory']
  end

  def image_definition_factory
    Indocker::Container['core.image_definition_factory']
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
    Indocker::Container['core.service_definition_factory']
  end

  def service_factory
    Indocker::Container['core.service_factory']
  end

  def service_definition(name)
    service_definition_factory.create(name)
  end

  def configuration_store
    Indocker::Container['core.configuration_store']
  end

  def configuration_definition_factory
    Indocker::Container['core.configuration_definition_factory']
  end

  def configuration_definition(name)
    configuration_definition_factory.create(name)
  end

  def add_registry(name, url)
    registry = Indocker::Core::Registries::Registry.new(name).set_remote_url(url)
    registry_store.add(registry)
  end

  def add_artifact(name, url)
    artifact = Indocker::Core::Artifacts::Git.new(name).setup(remote_url: url)
    artifact_store.add(artifact)
  end
end