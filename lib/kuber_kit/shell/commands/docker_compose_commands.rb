class KuberKit::Shell::Commands::DockerComposeCommands
  def run(shell, path, service:, command:, interactive: false, detached: false)
    command_parts = [
      "docker-compose",
      "-f #{path}",
      "run",
    ]
    
    if detached
      command_parts << "-d"
    end

    command_parts << service
    command_parts << command
    
    if interactive
      shell.interactive!(command_parts.join(" "))
    else
      shell.exec!(command_parts.join(" "))
    end
  end
end