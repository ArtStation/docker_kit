class KuberKit::Tools::WorkdirDetector
  include KuberKit::Import[
    "configs"
  ]

  def call(options)
    workdir_path = options[:path] || 
                   ENV['KUBER_KIT_PATH'] ||
                   File.join(Dir.pwd, configs.kuber_kit_dirname)

    workdir_path
  end
end