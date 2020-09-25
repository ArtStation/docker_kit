Indocker
  .define_image(:good_container)
  .registry(:default)
  .depends_on(:parent_container)