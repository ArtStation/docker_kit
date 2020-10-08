class Indocker::ArtifactsSync::GitCloner

  include Indocker::Import[
    "shell.git_commands",
  ]

  Contract Indocker::Shell::AbstractShell, Indocker::Core::Artifacts::Git => Any
  def clone(shell, artifact)
    already_cloned = artifact_already_cloned?(
      shell:       shell,
      target_path: artifact.cloned_path,
      remote_url:  artifact.remote_url,
    )

    if already_cloned
      git_commands.force_pull_repo(shell, 
        path: artifact.cloned_path, name: artifact.branch
      )
    else
      git_commands.download_repo(shell, 
        remote_url: artifact.remote_url, path: artifact.cloned_path, name: artifact.branch
      )
    end
  end

  private
    def artifact_already_cloned?(shell:, target_path:, remote_url:)
      target_remote_url = git_commands.get_remote_url(shell, target_path)
      target_remote_url == remote_url
    end
end