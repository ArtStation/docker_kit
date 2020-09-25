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
  
  def image(name)
    definition = image_definition(name)
    image_factory.create(definition)
  end
end