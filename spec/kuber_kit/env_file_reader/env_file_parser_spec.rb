RSpec.describe KuberKit::EnvFileReader::EnvFileParser do
  subject{ KuberKit::EnvFileReader::EnvFileParser.new }

  let(:env_file_content) { 
<<-ENV
    RUBY_ENV=review
    APP_NAME="KuberKit"
    ITEMS_COUNT=5
    ENABLED=true
    # Some comment
    TITLE = KuberKit==Good
ENV
  }

  it "returns parsed content of the artifact" do
    result = subject.call(env_file_content)
    expect(result).to eq({
      "RUBY_ENV"    => "review",
      "APP_NAME"    => "KuberKit",
      "ENABLED"     => "true",
      "TITLE"       => "KuberKit==Good",
      "ITEMS_COUNT" => "5"
    })
  end
end