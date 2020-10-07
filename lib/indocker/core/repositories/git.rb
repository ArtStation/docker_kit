class Indocker::Core::Repositories::Git < Indocker::Core::Repositories::AbstractRepository
  attr_reader :remote_url, :remote_name, :email, :password, :branch, :ssh_key

  DEFAULT_SSH_KEY = "id_rsa"
  DEFAULT_REMOTE_NAME = "origin"
  DEFAULT_BRANCH = "master"

  def setup(remote_url:, remote_name: DEFAULT_REMOTE_NAME, email: nil, password: nil, branch: DEFAULT_BRANCH, clone_path: nil, ssh_key: DEFAULT_SSH_KEY)
    @remote_name = remote_name
    @remote_url = remote_url
    @email = email
    @password = password
    @branch = branch
    @clone_path = clone_path
    @ssh_key = ssh_key
    self
  end

  def project_name
    @remote_url.split('/').last.gsub('.git', '')
  end

  def clone_path
    # TODO: clone path should not call configuration
    @clone_path || "/tmp/#{Indocker.configuration.name}/repositories/git/#{project_name}/#{branch}"
  end
end