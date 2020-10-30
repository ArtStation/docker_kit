class TestFilePresenceChecker < KuberKit::Tools::FilePresenceChecker
  def file_checked?(file_path)
    @checked_files ||= []
    @checked_files.include?(file_path)
  end

  def file_exists?(file_path)
    @checked_files ||= []
    @checked_files.push(file_path)
    return !lost_path?(file_path)
  end

  def dir_checked?(dir_path)
    @checked_dirs ||= []
    @checked_dirs.include?(dir_path)
  end

  def dir_exists?(dir_path)
    @checked_dirs ||= []
    @checked_dirs.push(dir_path)
    return !lost_path?(dir_path)
  end

  def lost_path!(path)
    @lost_paths ||= []
    @lost_paths.push(path)
  end

  def lost_path?(path)
    @lost_paths ||= []
    @lost_paths.include?(path)
  end

  def reset!
    @lost_paths = []
  end
end