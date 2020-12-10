class KuberKit::Shell::Commands::DockerComposeCommands
  def run(shell, path, service:, command:)
    shell.exec!(%Q{docker-compose -f #{path} run #{service} #{command}})
  end
end