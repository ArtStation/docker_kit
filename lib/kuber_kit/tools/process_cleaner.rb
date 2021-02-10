class KuberKit::Tools::ProcessCleaner
  include KuberKit::Import[
    "shell.system_commands",
    "shell.local_shell"
  ]

  def clean
    stop_threads
    stop_child_proceses
  end

  def stop_threads
    Thread.list.each do |t| 
      t.abort_on_exception   = false
      t.report_on_exception  = false
      Thread.kill(t) if t != Thread.current
    end
  end

  def stop_child_proceses
    find_all_child_processes.each do |pid|
      system_commands.kill_process(local_shell, pid)
    end
  end

  private

    def find_all_child_processes
      pids = system_commands.find_pids_by_name(local_shell, "[K]IT=#{Process.pid}")
      pids + get_child_pids(pids)
    end

    def get_child_pids(pids)
      pids
        .map{ |p| system_commands.get_child_pids(local_shell, p) }
        .flatten
    end
end