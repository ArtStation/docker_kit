class DockerKit::ArtifactsSync::GitArtifactResolver < DockerKit::ArtifactsSync::AbstractArtifactResolver

  include DockerKit::Import[
    "shell.git_commands",
  ]

  Contract DockerKit::Shell::AbstractShell, DockerKit::Core::Artifacts::Git => Any
  def resolve(shell, artifact)
    already_cloned = artifact_already_cloned?(
      shell:       shell,
      target_path: artifact.cloned_path,
      remote_url:  artifact.remote_url,
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

  private
    def artifact_already_cloned?(shell:, target_path:, remote_url:)
      target_remote_url = git_commands.get_remote_url(shell, target_path)
      target_remote_url == remote_url
    end
end