class Indocker::Shell::RsyncCommands
  def rsync(shell, source_path, target_path, exclude: nil)
    # Add a trailing slash to directory to have behavior similar to CP command
    if path_is_directory?(source_path) && !source_path.end_with?("/")
      source_path = "#{source_path}/"
    end

    args = [source_path, target_path]
    if exclude
      args << "--exclude=#{exclude}"
    end

    shell.exec!(%Q{rsync #{args.join(' ')}})
  end

  private
    def path_is_directory?(path)
      File.directory?(path)
    end
end