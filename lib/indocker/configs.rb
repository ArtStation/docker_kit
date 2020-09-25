class Indocker::Configs
  IMAGE_DOCKERFILE_NAME = "Dockerfile".freeze
  IMAGE_BUILD_CONTEXT_DIR = "build_context".freeze
  IMAGE_TAG = 'latest'.freeze
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
                :docker_ignore_list

  def initialize
    @image_dockerfile_name   = IMAGE_DOCKERFILE_NAME
    @image_build_context_dir = IMAGE_BUILD_CONTEXT_DIR
    @image_tag               = IMAGE_TAG
    @docker_ignore_list      = DOCKER_IGNORE_LIST
  end
end