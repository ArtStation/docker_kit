require 'time'
class KuberKit::Shell::Commands::BashCommands
  def rm(shell, path)
    shell.exec!(%Q{rm "#{path}"}, merge_stderr: true)
  end

  def rm_rf(shell, path)
    shell.exec!(%Q{rm -rf "#{path}"}, merge_stderr: true)
  end

  def cp(shell, source_path, dest_path)
    shell.exec!(%Q{cp "#{source_path}" "#{dest_path}"}, merge_stderr: true)
  end

  def cp_r(shell, source_path, dest_path)
    shell.exec!(%Q{cp -r "#{source_path}" "#{dest_path}"}, merge_stderr: true)
  end

  def mkdir(shell, path)
    shell.exec!(%Q{mkdir "#{path}"}, merge_stderr: true)
  end

  def mkdir_p(shell, path)
    shell.exec!(%Q{mkdir -p "#{path}"}, merge_stderr: true)
  end

  def ctime(shell, path)
    result = shell.exec!(%Q{date -r "#{path}"})
    Time.parse(result)
  end
end