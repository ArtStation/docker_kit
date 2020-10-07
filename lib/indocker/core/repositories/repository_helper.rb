class Indocker::Core::Repositories::RepositoryHelper
  Contract Indocker::Core::Repositories::AbstractRepository => String

  def clone_path(repository)
    "/tmp/#{Indocker.current_configuration.name}/repositories/#{repository.namespace}"
  end
end