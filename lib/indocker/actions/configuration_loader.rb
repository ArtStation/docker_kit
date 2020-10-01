class Indocker::Actions::ConfigurationLoader
  include Indocker::Import[
    "core.infra_store",
    "core.image_store",
    "ui"
  ]

  Contract Hash => Any
  def call(options)
    ui.create_task("Loading infrastructure") do |task|
      infra_store.add_registry(Indocker::Core::Registry.new(:default))
      task.update_title("Loaded infrastructure")
    end

    ui.create_task("Loading image definitions") do |task|
      files = image_store.load_definitions(options[:images_path])
      task.update_title("Loaded #{files.count} image definitions")
    end
  end
end