class Indocker::Core::Repositories::AbstractRepository
  include Indocker::Extensions::Inspectable

  attr_reader :repository_name

  def initialize(repository_name)
    @repository_name = repository_name
  end

  def project_name
    raise Indocker::NotImplementedError, "must be implemented"
  end

  def root_path
    raise Indocker::NotImplementedError, "must be implemented"
  end

  def clone_path
    raise Indocker::NotImplementedError, "must be implemented"
  end
end