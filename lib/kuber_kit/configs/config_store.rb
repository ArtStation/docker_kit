class KuberKit::Configs::ConfigStore
  def initialize
    @@items = {}
  end

  def set(key, value)
    @@items[key] = value
  end

  def get(key)
    @@items[key]
  end
end