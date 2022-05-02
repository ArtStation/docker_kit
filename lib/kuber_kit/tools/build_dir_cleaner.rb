class KuberKit::Tools::BuildDirCleaner
  include KuberKit::Import[
    "shell.bash_commands",
  ]

  KEEP_DIRS_COUNT = 10

  Contract KuberKit::Shell::AbstractShell, KeywordArgs[parent_dir: String] => Any
  def call(shell, parent_dir:)
    dirs_to_delete = get_ancient_builds_dirs(shell, parent_dir: parent_dir)

    dirs_to_delete.each do |dir|
      bash_commands.rm_rf(shell, dir)
    end
  end

  private
    def get_ancient_builds_dirs(shell, parent_dir:)
      all_dirs  = shell.list_dirs("#{parent_dir}/*")

      all_dirs.each do |dir|
        puts bash_commands.ctime(shell, f).inspect
      end

      skip_dirs = all_dirs
        .sort_by{ |f| bash_commands.ctime(shell, f) }
        .reverse[0...KEEP_DIRS_COUNT]

      all_dirs - skip_dirs
    end
end