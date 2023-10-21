class KuberKit::Core::ContextHelper::ServiceHelper < KuberKit::Core::ContextHelper::BaseHelper
  def initialize(image_store:, artifact_store:, shell:, env_file_reader:, service:, template_renderer:)
    super(
      image_store:      image_store, 
      artifact_store:   artifact_store, 
      shell:            shell,
      env_file_reader:  env_file_reader
    )
    @service = service
    @template_renderer = template_renderer
  end

  def service_name
    @service.name.to_s
  end

  def service_uri
    @service.uri
  end

  def attribute(attribute_name, default: nil)
    @service.attribute(attribute_name, default: default)
  end

  Contract Maybe[String, Symbol], Hash => String
  def render(template_name, variables = {})
    context_helper = KuberKit::Core::ContextHelper::LocalContextHelper.new(
      parent_context_helper: self,
      variables: variables
    )
    @template_renderer.call(shell, template_name.to_sym, context_helper: context_helper)
  end

  def method_missing(m, *args, &block)
    raise("Unknown variable: #{m} while rendering '#{service_name}' with '#{@service.template_name}' template.")
  end
end