class KuberKit::EnvFileReader::EnvFileParser
  # Parser is based on:
  # https://github.com/bkeepers/dotenv/blob/master/lib/dotenv/parser.rb
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

  Contract String => Hash
  def call(string)
    hash = {}
    string.gsub(/\r\n?/, "\n").scan(LINE).each do |key, value|
      hash[key] = parse_value(value || "")
    end
    hash
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