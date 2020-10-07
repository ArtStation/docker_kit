class Indocker::Core::Repositories::GitCloner

  include Indocker::Import[
    "shell.git_commands",
  ]

  Contract Indocker::Shell::AbstractShell, Indocker::Core::Repositories::Git => Any
  def clone(shell, repository)
    already_cloned = repository_already_cloned?(
      shell:       shell,
      target_path: repository.cloned_path,
      remote_url:  repository.remote_url,
    )

    if already_cloned
      git_commands.force_pull_repo(shell, 
        path: repository.cloned_path, name: repository.branch
      )
    else
      git_commands.download_repo(shell, 
        remote_url: repository.remote_url, path: repository.cloned_path, name: repository.branch
      )
    end
  end

  private
    def repository_already_cloned?(shell:, target_path:, remote_url:)
      target_remote_url = git_commands.get_remote_url(shell, target_path)
      target_remote_url == remote_url
    end
end