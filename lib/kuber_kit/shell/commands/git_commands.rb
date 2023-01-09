class KuberKit::Shell::Commands::GitCommands
  def get_remote_url(shell, git_repo_path, remote_name: "origin")
    shell.exec!([
      "cd #{git_repo_path}",
      "git config --get remote.#{remote_name}.url",
    ].join(" && "), merge_stderr: true)
  rescue KuberKit::Shell::AbstractShell::ShellError
    return nil
  end

  def get_version_hash(shell, git_repo_path)
    shell.exec!([
      "cd #{git_repo_path}",
      "git rev-parse --short HEAD",
    ].join(" && "), merge_stderr: true)
  end

  def download_repo(shell, remote_url:, path:, branch:)
    shell.exec!([
      "rm -rf #{path}",
      "mkdir -p #{path}",
      "git clone -b #{branch} --depth 1 #{remote_url} #{path}",
    ].join(" && "), merge_stderr: true)
  end

  def force_pull_repo(shell, path:, branch:)
    shell.exec!([
      "cd #{path}",
      "git add .",
      "git reset HEAD --hard",
      "git checkout #{branch}",
      "git reset --hard '@{u}'",
      "git pull --force",
    ].join(" && "), merge_stderr: true)
  end
end