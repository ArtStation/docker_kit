class Indocker::Core::Repositories::RepositoryStore
  NotFoundError = Class.new(Indocker::NotFoundError)
  AlreadyAddedError = Class.new(Indocker::Error)

  include Indocker::Import[
    "shell.local_shell"
  ]

  def add(repository)
    @@repositories ||= {}

    if !repository.is_a?(Indocker::Core::Repositories::AbstractRepository)
      raise ArgumentError.new("should be an instance of Indocker::Core::Repositories::AbstractRepository, got: #{repository.inspect}")
    end

    unless @@repositories[repository.repository_name].nil?
      raise AlreadyAddedError, "repository #{repository.repository_name} was already added"
    end

    @@repositories[repository.repository_name] = repository
  end

  def get(repository_name)
    repository = get_from_configuration(repository_name) || 
               get_global(repository_name)

    repository
  end

  def get_global(repository_name)
    @@repositories ||= {}
    repository = @@repositories[repository_name]

    if repository.nil?
      raise NotFoundError, "repository #{repository_name} not found"
    end
    
    repository
  end

  def get_from_configuration(repository_name)
    repositories = Indocker.current_configuration.repositories
    repositories[repository_name]
  end

  def reset!
    @@repositories = {}
  end
end