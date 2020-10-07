class Indocker::Compiler::ContextHelperFactory
  include Indocker::Import[
    "core.image_store",
    "core.repository_store"
  ]

  def create
    Indocker::Compiler::ContextHelper.new(
      image_store: image_store,
      repository_store: repository_store
    )
  end
end