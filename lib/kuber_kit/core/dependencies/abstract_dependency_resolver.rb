class KuberKit::Core::Dependencies::AbstractDependencyResolver
  CircularDependencyError = Class.new(KuberKit::Error)
  DependencyNotFoundError = Class.new(KuberKit::NotFoundError)

  # Iterate over list of dependencies for items (including the items themself).
  # Iteration will send the list to the callback block function
  Contract Or[Symbol, ArrayOf[Symbol]], Proc => Any
  def each_with_deps(item_names, &block)
    resolved_dependencies = []
    # Get first list of dependencies ready to resolve
    next_dependencies = get_next(item_names, limit: dependency_batch_size)

    # Call the block for each list of dependencies ready to resolve, then calculate the next list
    while (next_dependencies - resolved_dependencies).any?
      block.call(next_dependencies)
      resolved_dependencies += next_dependencies
      next_dependencies = get_next(item_names, resolved: resolved_dependencies, limit: dependency_batch_size)
    end

    (item_names - resolved_dependencies).each_slice(dependency_batch_size) do |group|
      block.call(group)
    end
  end
  
  # Returns next list of dependencies ready to resolve.
  # Item is not ready to resolve if it has personal dependency.
  # E.g. if "A" depends on "B" and "C", "C" depends on "D", then only "B" and "D" will be returned. 
  Contract Or[Symbol, ArrayOf[Symbol]], KeywordArgs[
    resolved: Optional[ArrayOf[Symbol]],
    limit:    Optional[Maybe[Num]]
  ] => Any
  def get_next(item_names, resolved: [], limit: nil)
    deps = Array(item_names).map { |i| get_recursive_deps(i) }.flatten.uniq

    # Find out which dependencies are ready to resolve, 
    # they should not have unresolved personal dependencies
    ready_to_resolve = deps.select do |dep_name|
      unresolved_deps = get_deps(dep_name) - resolved
      unresolved_deps.empty?
    end
    unresolved_deps = ready_to_resolve - resolved
    unresolved_deps = unresolved_deps.take(limit) if limit
    unresolved_deps
  end

  # Get all dependencies for items (including the items themself), without any limitations
  Contract Or[Symbol, ArrayOf[Symbol]] => Any
  def get_all(item_names)
    deps = Array(item_names).map { |i| get_recursive_deps(i) }.flatten
    (deps + item_names).uniq
  end

  def get_recursive_deps(item_name, dependency_tree: [])
    deps = get_deps(item_name)

    if dependency_tree.include?(item_name)
      raise CircularDependencyError, "Circular dependency found for #{item_name}. Dependency tree: #{dependency_tree.inspect}"
    end

    child_deps = []
    deps.each do |i| 
      child_deps += get_recursive_deps(i, dependency_tree: dependency_tree + [item_name])
    end

    (deps + child_deps).uniq
  end

  def get_deps(item_name)
    raise "This method should be overriden"
  end

  def dependency_batch_size
    raise "This method should be overriden"
  end
end