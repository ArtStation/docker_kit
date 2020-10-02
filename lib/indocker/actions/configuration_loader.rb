class Indocker::Actions::ConfigurationLoader
  include Indocker::Import[
    "core.infra_store",
    "core.image_store",
    "core.configuration_store",
    "ui"
  ]

  Contract Hash => Any
  def call(options)
    ui.create_task("Loading configuration") do |task|
      configuration_store.define(:default)
      Indocker.set_configuration_name(:default)

      infra_store.add_registry(Indocker::Core::Registry.new(:default))
      task.update_title("Loaded infrastructure")
    end

    ui.create_task("Loading image definitions") do |task|
      files = image_store.load_definitions(options[:images_path])
      task.update_title("Loaded #{files.count} image definitions")
    end
  end
end