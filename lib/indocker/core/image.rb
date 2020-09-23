class Indocker::Core::Image < Dry::Struct
  attribute :name,                  Types::Coercible::Symbol
  attribute :dependent_images,      Types::Array.of(self).optional
  attribute :registry_name,         Types::Coercible::Symbol.optional
  attribute :dockerfile_path,       Types::Coercible::String.optional
  attribute :build_args,            Types::Hash.optional
  attribute :build_context_dir,     Types::Coercible::String.optional
  attribute :tag,                   Types::Coercible::String.optional
  attribute :before_build_callback, Types.Instance(Proc).optional
  attribute :after_build_callback,  Types.Instance(Proc).optional
end