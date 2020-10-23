class Indocker::Core::Templates::TemplateStore
  NotFoundError = Class.new(Indocker::NotFoundError)
  AlreadyAddedError = Class.new(Indocker::Error)

  def add(template)
    @@templates ||= {}

    if !template.is_a?(Indocker::Core::Templates::AbstractTemplate)
      raise ArgumentError.new("should be an instance of Indocker::Core::Templates::AbstractTemplate, got: #{template.inspect}")
    end

    unless @@templates[template.template_name].nil?
      raise AlreadyAddedError, "template #{template.template_name} was already added"
    end

    @@templates[template.template_name] = template
  end

  def get(template_name)
    template = get_from_configuration(template_name) || 
               get_global(template_name)

    template
  end

  def get_global(template_name)
    @@templates ||= {}
    template = @@templates[template_name]

    if template.nil?
      raise NotFoundError, "template #{template_name} not found"
    end
    
    template
  end

  def get_from_configuration(template_name)
    templates = Indocker.current_configuration.templates
    templates[template_name]
  end

  def reset!
    @@templates = {}
  end
end