class TestHelper
  class HelloWorldContextHelper
    def hello_world
      "hello world"
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
    Indocker::Container['core.registry_store'].add(registry)
  end

  def add_artifact(name, url)
    artifact = Indocker::Core::Artifacts::Git.new(name).setup(remote_url: url)
    Indocker::Container['core.artifact_store'].add(artifact)
  end
end