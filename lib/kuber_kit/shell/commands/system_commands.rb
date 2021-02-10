class KuberKit::Shell::Commands::SystemCommands
  def kill_process(shell, pid)
    # we need to use kill command directly sometimes, 
    # because Process.kill doesn't kill processes created by system() call
    shell.exec!("kill -9 #{pid}")
    true
  rescue
    false
  end

  def find_pids_by_name(shell, name)
    shell
      .exec!("ps auxww | grep '#{name}' | grep -v 'grep' | awk '{print $2}'")
      .split("\n")
      .reject(&:empty?)
      .map(&:chomp)
      .map(&:to_i)
  rescue
    []
  end

  def get_child_pids(shell, pid)
    shell
      .exec!("pgrep -P #{pid}")
      .split("\n")
      .reject(&:empty?)
      .map(&:chomp)
      .map(&:to_i)
  rescue
    []
  end
end