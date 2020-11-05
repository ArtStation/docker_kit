class KuberKit::Core::Store
  NotFoundError = Class.new(KuberKit::NotFoundError)
  AlreadyAddedError = Class.new(KuberKit::Error)

  attr_reader :object_class_name

  def initialize(object_class_name)
    @object_class_name = object_class_name
  end

  def add(item_name, item)
    unless item.is_a?(object_class_name)
      raise ArgumentError.new("#{self.object_class_name}: should be an instance of #{object_class_name}, got: #{item.inspect}")
    end

    unless items[item_name].nil?
      raise AlreadyAddedError, "#{self.object_class_name}: item with name #{item_name} was already added"
    end

    items[item_name] = item
  end

  def get(item_name)
    item = items[item_name]

    if item.nil?
      raise NotFoundError, "#{self.object_class_name}: item '#{item_name}' not found"
    end

    item
  end

  def items
    @items ||= {}
  end

  def reset!
    @items = {}
  end

  def size
    items.count
  end

  def exists?(name)
    !items[name].nil?
  end
end