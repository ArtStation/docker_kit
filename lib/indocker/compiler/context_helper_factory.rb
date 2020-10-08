class Indocker::Compiler::ContextHelperFactory
  include Indocker::Import[
    "core.image_store",
    "core.artifact_store"
  ]

  def create(shell)
    Indocker::Compiler::ContextHelper.new(
      image_store: image_store,
      artifact_store: artifact_store,
      shell: shell
    )
  end
end