class KuberKit::Configs::Config
  include KuberKit::Import[
    "configs.config_store"
  ]

  IMAGE_DOCKERFILE_NAME = "Dockerfile".freeze
  IMAGE_BUILD_CONTEXT_DIR = "build_context".freeze
  IMAGE_TAG = 'latest'.freeze
  IMAGE_COMPILE_DIR = "/tmp/kuber_kit/image_builds"
  DOCKER_IGNORE_LIST = [
    'Dockerfile',
    '.DS_Store',
    '**/.DS_Store',
    '**/*.log',
    'node_modules',
    '.vagrant',
    '.vscode',
    'tmp',
    'logs'
  ]
  KUBER_KIT_DIRNAME           = "kuber_kit".freeze
  IMAGES_DIRNAME              = "images".freeze
  SERVICES_DIRNAME            = "services".freeze
  INFRA_DIRNAME               = "infrastructure".freeze
  CONFIGURATIONS_DIRNAME      = "configurations".freeze
  ARTIFACT_CLONE_DIR          = "/tmp/kuber_kit/artifacts"
  SERVICE_CONFIG_DIR          = "/tmp/kuber_kit/services"
  DEPLOY_STRATEGY             = :kubernetes
  COMPILE_SIMULTANEOUS_LIMIT  = 5

  attr_accessor :image_dockerfile_name, :image_build_context_dir, :image_tag,
                :docker_ignore_list, :image_compile_dir, 
                :kuber_kit_dirname, :images_dirname, :services_dirname, :infra_dirname, :configurations_dirname,
                :artifact_clone_dir, :service_config_dir, :deploy_strategy, :compile_simultaneous_limit

  def initialize(**injected_deps)
    super(injected_deps)

    @image_dockerfile_name      = config_store.get("image_dockerfile_name") || IMAGE_DOCKERFILE_NAME
    @image_build_context_dir    = config_store.get("image_build_context_dir") || IMAGE_BUILD_CONTEXT_DIR
    @image_tag                  = config_store.get("image_tag") || IMAGE_TAG
    @image_compile_dir          = config_store.get("image_compile_dir") || IMAGE_COMPILE_DIR
    @docker_ignore_list         = config_store.get("docker_ignore_list") || DOCKER_IGNORE_LIST
    @kuber_kit_dirname          = config_store.get("kuber_kit_dirname") || KUBER_KIT_DIRNAME
    @images_dirname             = config_store.get("images_dirname") || IMAGES_DIRNAME
    @services_dirname           = config_store.get("services_dirname") || SERVICES_DIRNAME
    @infra_dirname              = config_store.get("infra_dirname") || INFRA_DIRNAME
    @configurations_dirname     = config_store.get("configurations_dirname") || CONFIGURATIONS_DIRNAME
    @artifact_clone_dir         = config_store.get("artifact_clone_dir") || ARTIFACT_CLONE_DIR
    @service_config_dir         = config_store.get("service_config_dir") || SERVICE_CONFIG_DIR
    @deploy_strategy            = config_store.get("deploy_strategy") || DEPLOY_STRATEGY
    @compile_simultaneous_limit = config_store.get("compile_simultaneous_limit") || COMPILE_SIMULTANEOUS_LIMIT
  end
end