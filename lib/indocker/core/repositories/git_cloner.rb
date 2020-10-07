class Indocker::Core::Repositories::GitCloner

  include Indocker::Import[
    "shell.git_commands",
    "core.repository_helper"
  ]

  Contract Indocker::Shell::AbstractShell, Indocker::Core::Repositories::Git => Any
  def clone(shell, repository)
    clone_path = repository_helper.clone_path(repository)

    already_cloned = repository_already_cloned?(
      shell:       shell,
      target_path: clone_path,
      remote_url:  repository.remote_url,
    )

    if already_cloned
      git_commands.force_pull_repo(shell, 
        path: clone_path, name: repository.branch
      )
    else
      git_commands.download_repo(shell, 
        remote_url: repository.remote_url, path: clone_path, name: repository.branch
      )
    end
  end
end