class KuberKit::Shell::Commands::HelmCommands
  def install(shell, release_name, chart_path)
    shell.exec!(%Q{helm install #{release_name} #{chart_path}}, merge_stderr: true)
  end

  def upgrade(shell, release_name, chart_path)
    shell.exec!(%Q{helm upgrade #{release_name} #{chart_path} --install}, merge_stderr: true)
  end
end