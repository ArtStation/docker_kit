class KuberKit::Core::Artifacts::Git < KuberKit::Core::Artifacts::AbstractArtifact
  attr_reader :remote_url, :remote_name, :email, :password, :branch, :ssh_key

  DEFAULT_SSH_KEY = "id_rsa"
  DEFAULT_REMOTE_NAME = "origin"
  DEFAULT_BRANCH = "master"

  def setup(remote_url:, remote_name: DEFAULT_REMOTE_NAME, branch: DEFAULT_BRANCH, clone_path: nil, ssh_key: DEFAULT_SSH_KEY)
    @remote_name = remote_name
    @remote_url = remote_url
    @branch = branch
    @clone_path = clone_path
    @ssh_key = ssh_key
    self
  end

  def cloned_path
    # TODO: We should refactor to not call container here
    configs = KuberKit::Container['configs']
    "#{configs.artifact_clone_dir}/#{name}"
  end

  def sync_description
    "#{remote_url}:#{branch}"
  end
end