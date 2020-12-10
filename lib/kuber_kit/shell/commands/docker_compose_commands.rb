class KuberKit::Shell::Commands::DockerComposeCommands
  def run(shell, path, service:, command:, interactive: false)
    command_parts = [
      "docker-compose",
      "-f #{path}",
      "run",
      service,
      command
    ]
    
    if interactive
      shell.interactive!(command_parts.join(" "))
    else
      shell.exec!(command_parts.join(" "))
    end
  end
end