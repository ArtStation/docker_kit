class Indocker::Core::Image < Dry::Struct
  attribute :name,                  Types::Coercible::Symbol
  attribute :dependencies,          Types::Array.of(Types::Coercible::Symbol).optional
  attribute :registry,              Types.Instance(Indocker::Infrastructure::Registry)
  attribute :dockerfile_path,       Types::Coercible::String.optional
  attribute :build_args,            Types::Hash.optional
  attribute :build_context_dir,     Types::Coercible::String.optional
  attribute :tag,                   Types::Coercible::String.optional
  attribute :before_build_callback, Types.Instance(Proc).optional
  attribute :after_build_callback,  Types.Instance(Proc).optional

  def registry_url
    "#{registry.path}/#{name}:#{tag}"
  end

  def remote_registry_url
    "#{registry.remote_path}/#{name}:#{tag}"
  end
end