class KuberKit::Shell::Commands::DockerComposeCommands
  def run(shell, path, service:, args: nil, command: nil, detached: false, interactive: false)
    command_parts = [
      "docker-compose",
      "-f #{path}",
      "run",
    ]
    

    command_parts << "-d" if detached
    command_parts << args if args
    command_parts << service
    command_parts << command if command
    
    if interactive
      shell.interactive!(command_parts.join(" "))
    else
      shell.exec!(command_parts.join(" "))
    end
  end
end