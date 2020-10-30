class KuberKit::Tools::FilesSync
  include KuberKit::Import[
    "shell.rsync_commands",
    "shell.local_shell"
  ]

  def sync(from_path, to_path, exclude: nil)
    rsync_commands.rsync(local_shell, from_path, to_path, exclude: exclude)
  end
end