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
  
  def image_factory
    Indocker::Core::ImageFactory.new(
      file_presence_checker: TestFilePresenceChecker.new
    )
  end

  def image_definition_factory
    TestImageDefinitionFactory.new
  end
  
  def image_definition(name)
    image_definition_factory.create(name)
  end
  
  def image(name, all_definitions: nil)
    definition = image_definition(name)
    all_definitions ||= [definition]

    image_factory.create(definition, all_definitions: all_definitions)
  end

  def remote_image(name, url)
    add_registry(:remote, url)
    remote_image_def = image_definition(:remote_image).registry(:remote)
    remote_image = image_factory.create(remote_image_def)
  end

  def add_registry(name, url)
    registry = Indocker::Infrastructure::Registry.new(name).set_remote_url(url)
    Indocker::Container['infrastructure.infra_store'].add_registry(registry)
  end
end