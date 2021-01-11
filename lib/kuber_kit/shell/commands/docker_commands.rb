class KuberKit::Shell::Commands::DockerCommands
  def build(shell, build_dir, args = [])
    default_args = ["--rm=true"]
    args_list = (default_args + args).join(" ")

    shell.exec!(%Q{docker build #{build_dir} #{args_list}})
  end

  def tag(shell, image_name, tag_name)
    shell.exec!(%Q{docker tag #{image_name} #{tag_name}})
  end

  def push(shell, tag_name)
    shell.exec!(%Q{docker push #{tag_name}})
  end

  def run(shell, image_name, args: nil, command: nil, detached: false, interactive: false)
    command_parts = []
    command_parts << "docker run"
    command_parts << "-d" if detached
    command_parts << Array(args).join(" ") if args
    command_parts << image_name
    command_parts << command if command

    if interactive
      shell.interactive!(command_parts.join(" "))
    else
      shell.exec!(command_parts.join(" "))
    end
  end

  def container_exists?(shell, container_name)
    result = get_container_id(shell, container_name)
    result && result != ""
  end

  def delete_container(shell, container_name)
    shell.exec!(%Q{docker rm -f #{container_name}})
  end

  def get_container_id(shell, container_name, only_healthy: false, status: "running")
    command_parts = []
    command_parts << "docker ps -a -q"

    if only_healthy
      command_parts << "--filter=\"health=healthy\""
    end

    command_parts << "--filter=\"status=#{status}\""
    command_parts << "--filter=\"name=#{container_name}\""

    shell.exec!(command_parts.join(" "))
  end
end