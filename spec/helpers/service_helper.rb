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

  def service(name, template_name = :service_template)
    service_definition = definition(name).template(template_name)
    factory.create(service_definition)
  end

  def register_service(name, template_name = :service_template)
    artifact = KuberKit::Core::Artifacts::Local.new(:templates).setup(File.join(FIXTURES_PATH, "templates"))
    template = KuberKit::Core::Templates::ArtifactFile.new(template_name, artifact_name: :templates, file_path: "service.yml")
    test_helper.artifact_store.add(artifact)
    test_helper.template_store.add(template)

    service_definition = store.define(name).template(template_name)
    factory.create(service_definition)
  end
end