class KuberKit::Configs::ConfigStore
  def items
    @@items ||= {}
  end

  def set(key, value)
    items[key] = value
  end

  def get(key)
    items[key]
  end

  def reset!
    @@items = {}
  end
end