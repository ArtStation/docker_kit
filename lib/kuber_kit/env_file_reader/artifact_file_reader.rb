class KuberKit::EnvFileReader::ArtifactFileReader < KuberKit::EnvFileReader::AbstractEnvFileReader
  include KuberKit::Import[
    "core.artifact_store"
  ]

  def read(shell, env_file)
    artifact = artifact_store.get(env_file.artifact_name)

    file_parts = [artifact.cloned_path, env_file.file_path].compact
    file_path  = File.join(*file_parts)

    read_file(shell, file_path)
  end

  private
    def read_file(shell, file_path)
      result = {}
      content = shell.read(file_path)
      Parser.call(content)
    end

  # Parser is based on:
  # https://github.com/bkeepers/dotenv/blob/master/lib/dotenv/parser.rb
  class Parser
    LINE = /
      (?:^|\A)              # beginning of line
      \s*                   # leading whitespace
      (?:export\s+)?        # optional export
      ([\w\.]+)             # key
      (?:\s*=\s*?|:\s+?)    # separator
      (                     # optional value begin
        \s*'(?:\\'|[^'])*'  #   single quoted value
        |                   #   or
        \s*"(?:\\"|[^"])*"  #   double quoted value
        |                   #   or
        [^\#\r\n]+          #   unquoted value
      )?                    # value end
      \s*                   # trailing whitespace
      (?:\#.*)?             # optional comment
      (?:$|\z)              # end of line
    /x

    class << self
      def call(string, is_load = false)
        new(string, is_load).call
      end
    end

    def initialize(string, is_load = false)
      @string = string
      @hash = {}
      @is_load = is_load
    end

    def call
      # Convert line breaks to same format
      lines = @string.gsub(/\r\n?/, "\n")
      # Process matches
      lines.scan(LINE).each do |key, value|
        @hash[key] = parse_value(value || "")
      end
      @hash
    end

    private

    def parse_value(value)
      # Remove surrounding quotes
      value = value.strip.sub(/\A(['"])(.*)\1\z/m, '\2')

      if Regexp.last_match(1) == '"'
        value = unescape_characters(expand_newlines(value))
      end

      value
    end

    def unescape_characters(value)
      value.gsub(/\\([^$])/, '\1')
    end

    def expand_newlines(value)
      value.gsub('\n', "\n").gsub('\r', "\r")
    end
  end
end