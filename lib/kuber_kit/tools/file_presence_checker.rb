class KuberKit::Tools::FilePresenceChecker
  FileNotFound = Class.new(KuberKit::Error)

  include KuberKit::Import[
    "shell.local_shell"
  ]

  def check_file!(file_path)
    unless file_exists?(file_path)
      raise FileNotFound, "File not found at path: #{file_path}"
    end
    true
  end

  def file_exists?(file_path)
    local_shell.file_exists?(file_path)
  end

  def check_dir!(dir_path)
    unless dir_exists?(dir_path)
      raise FileNotFound, "Directory not found at path: #{dir_path}"
    end
    true
  end

  def dir_exists?(dir_path)
    local_shell.dir_exists?(dir_path)
  end
end