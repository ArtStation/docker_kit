class Indocker::Actions::ConfigurationLoader
  include Indocker::Import[
    "core.infra_store",
    "core.image_store",
    "core.configuration_store",
    "ui",
    "configs"
  ]

  Contract Hash => Any
  def call(options)
    root_path   = options[:path] || File.join(Dir.pwd, configs.indocker_dirname)
    images_path = options[:images_path] || File.join(root_path, configs.images_dirname)
    infra_path  = options[:infra_path]  || File.join(root_path, configs.infra_dirname)

    puts "Launching indocker with:".yellow
    puts "  Root path: #{root_path}".yellow

    ui.create_task("Loading configuration") do |task|
      configuration_store.define(:default)
      Indocker.set_configuration_name(:default)

      infra_store.load_infra_items(infra_path)
      task.update_title("Loaded infrastructure")
    end

    ui.create_task("Loading image definitions") do |task|
      files = image_store.load_definitions(images_path)
      task.update_title("Loaded #{files.count} image definitions")
    end
  end
end