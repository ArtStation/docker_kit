class KuberKit::Core::Templates::TemplateStore
  def add(template)
    store.add(template.name, template)
  end

  def get(template_name)
    template = get_from_configuration(template_name) || 
               get_global(template_name)

    template
  end

  def get_global(template_name)
    store.get(template_name)
  end

  def get_from_configuration(template_name)
    templates = KuberKit.current_configuration.templates
    templates[template_name]
  end

  def reset!
    store.reset!
  end

  def exists?(template_name)
    store.exists?(template_name)
  end

  private
    def store
      @@store ||= KuberKit::Core::Store.new(KuberKit::Core::Templates::AbstractTemplate)
    end
end