class KuberKit::ArtifactsSync::Strategies::GitUpdater < KuberKit::ArtifactsSync::Strategies::Abstract

  include KuberKit::Import[
    "shell.git_commands",
    "shell.bash_commands",
  ]

  Contract KuberKit::Shell::AbstractShell, KuberKit::Core::Artifacts::Git => Any
  def update(shell, artifact)
    already_cloned = artifact_already_cloned?(
      shell:      shell,
      repo_path:  artifact.cloned_path,
      artifact:   artifact
    )

    if already_cloned
      git_commands.force_pull_repo(shell, 
        path: artifact.cloned_path, branch: artifact.branch
      )
    else
      git_commands.download_repo(shell, 
        remote_url: artifact.remote_url, path: artifact.cloned_path, branch: artifact.branch
      )
    end
  end

  Contract KuberKit::Shell::AbstractShell, KuberKit::Core::Artifacts::Git => Any
  def cleanup(shell, artifact)
    bash_commands.rm_rf(shell, artifact.cloned_path)
  end

  private
    def artifact_already_cloned?(shell:, repo_path:, artifact:)
      target_remote_url = git_commands.get_remote_url(shell, repo_path)
      if target_remote_url != artifact.remote_url
        return false
      end

      target_branch = git_commands.get_branch_name(shell, repo_path)
      if target_branch != artifact.branch.to_s
        return false
      end

      return true
    end
end