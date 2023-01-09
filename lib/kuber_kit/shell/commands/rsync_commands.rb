class KuberKit::Shell::Commands::RsyncCommands
  def rsync(shell, source_path, target_path, target_host: nil, exclude: nil, delete: true)
    # Add a trailing slash to directory to have behavior similar to CP command
    if path_is_directory?(source_path) && !source_path.end_with?("/")
      source_path = "#{source_path}/"
    end

    if target_host
      destination = "#{target_host}:#{target_path}"
    else
      destination = target_path
    end

    args = [source_path, destination]
    if exclude
      Array(exclude).each do |e|
        args << "--exclude=#{e}"
      end
    end

    if delete
      args << "--delete"
    end

    shell.exec!(%Q{rsync -a #{args.join(' ')}}, merge_stderr: true)
  end

  private
    def path_is_directory?(path)
      File.directory?(path)
    end
end