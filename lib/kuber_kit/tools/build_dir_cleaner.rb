class KuberKit::Tools::BuildDirCleaner
  include KuberKit::Import[
    "shell.bash_commands",
    "shell.local_shell",
  ]

  KEEP_DIRS_COUNT = 10

  def call(parent_dir:)
    dirs_to_delete = get_ancient_builds_dirs(parent_dir: parent_dir)

    dirs_to_delete.each do |dir|
      bash_commands.rm_rf(local_shell, dir)
    end
  end

  private
    def get_ancient_builds_dirs(parent_dir:)
      all_dirs  = Dir.glob("#{parent_dir}/*")
      skip_dirs = all_dirs
        .sort_by{ |f| File.ctime(f) }
        .reverse[0...KEEP_DIRS_COUNT]

      all_dirs - skip_dirs
    end
end