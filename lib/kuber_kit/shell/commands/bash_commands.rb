class KuberKit::Shell::Commands::BashCommands
  def rm(shell, path)
    absolute_path = shell.expand_path(path)
    shell.exec!(%Q{rm "#{absolute_path}"})
  end

  def rm_rf(shell, path)
    absolute_path = shell.expand_path(path)
    shell.exec!(%Q{rm -rf "#{absolute_path}"})
  end

  def cp(shell, source_path, dest_path)
    abs_source_path = shell.expand_path(source_path)
    abs_dest_path = shell.expand_path(dest_path)

    shell.exec!(%Q{cp "#{abs_source_path}" "#{abs_dest_path}"})
  end

  def cp_r(shell, source_path, dest_path)
    abs_source_path = shell.expand_path(source_path)
    abs_dest_path = shell.expand_path(dest_path)

    shell.exec!(%Q{cp -r "#{abs_source_path}" "#{abs_dest_path}"})
  end

  def mkdir(shell, path)
    absolute_path = shell.expand_path(path)
    shell.exec!(%Q{mkdir "#{absolute_path}"})
  end

  def mkdir_p(shell, path)
    absolute_path = shell.expand_path(path)
    shell.exec!(%Q{mkdir -p "#{absolute_path}"})
  end
end