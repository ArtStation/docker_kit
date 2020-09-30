Indocker
  .define_image(:ruby_app)
  .registry(:default)
  .depends_on(:ruby, :app_sources)