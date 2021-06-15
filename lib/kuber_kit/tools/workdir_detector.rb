class KuberKit::Tools::WorkdirDetector
  include KuberKit::Import[
    "configs",
    "tools.file_presence_checker"
  ]

  def call(options, current_dir: nil)
    current_dir ||= Dir.pwd
    default_dir   = File.join(current_dir, configs.kuber_kit_dirname)
    workdir_path  = options[:path] || ENV['KUBER_KIT_PATH'] || default_dir

    unless file_presence_checker.dir_exists?(workdir_path)
      workdir_in_ancestors = find_workdir_in_ancestors(current_dir)
      workdir_path = workdir_in_ancestors if workdir_in_ancestors
    end

    workdir_path
  end

  private
    def find_workdir_in_ancestors(dir)
      if dir == "/"
        return nil
      end

      workdir_path = File.join(dir, configs.kuber_kit_dirname)
      if file_presence_checker.dir_exists?(workdir_path)
        return workdir_path
      end

      find_workdir_in_ancestors(File.dirname(dir))
    end
end