class Indocker::Configs
  IMAGE_DOCKERFILE_NAME = "Dockerfile".freeze
  IMAGE_BUILD_CONTEXT_DIR = "build_context".freeze
  IMAGE_TAG = 'latest'.freeze
  IMAGE_COMPILE_DIR = "/tmp/indocker/image_builds"
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

  attr_accessor :image_dockerfile_name, :image_build_context_dir, :image_tag,
                :docker_ignore_list, :image_compile_dir

  def initialize
    @image_dockerfile_name   = IMAGE_DOCKERFILE_NAME
    @image_build_context_dir = IMAGE_BUILD_CONTEXT_DIR
    @image_tag               = IMAGE_TAG
    @image_compile_dir       = IMAGE_COMPILE_DIR
    @docker_ignore_list      = DOCKER_IGNORE_LIST
  end
end