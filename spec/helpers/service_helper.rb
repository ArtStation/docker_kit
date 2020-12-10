class ServiceHelper
  def store
    KuberKit::Container['core.service_store']
  end

  def definition_factory
    KuberKit::Container['core.service_definition_factory']
  end

  def factory
    KuberKit::Container['core.service_factory']
  end

  def definition(name)
    definition_factory.create(name)
  end

  def service(name, template: :service_template, attributes: {}, deployer_strategy: nil)
    setup_service_template(template)

    service_definition = definition(name).template(template).attributes(attributes).deployer_strategy(deployer_strategy)
    factory.create(service_definition)
  end

  def register_service(name, template_name = :service_template)
    setup_service_template(template_name)
    
    service_definition = store.define(name).template(template_name)
    factory.create(service_definition)
  end

  def setup_service_template(template_name)
    unless test_helper.artifact_store.exists?(:templates)
      artifact = KuberKit::Core::Artifacts::Local.new(:templates).setup(File.join(FIXTURES_PATH, "templates"))
      test_helper.artifact_store.add(artifact)
    end

    unless test_helper.artifact_store.exists?(template_name)
      template = KuberKit::Core::Templates::ArtifactFile.new(template_name, artifact_name: :templates, file_path: "service.yml")
      test_helper.template_store.add(template)
    end
  end
end