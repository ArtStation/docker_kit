RSpec.describe KuberKit::Preprocessing::TextPreprocessor do
  subject{ KuberKit::Preprocessing::TextPreprocessor.new }

  it "returns original content if not a erb template" do
    expect(subject.compile("test")).to eq("test")
  end

  it "compiles erb content" do
    expect(subject.compile("<%= 'test' %>\r\ntest")).to eq("test\r\ntest")
  end

  it "returns an error if syntax is not correct" do
    expect{subject.compile("<%= 'test %>")}.to raise_error(SyntaxError)
  end

  it "allows using a context helper" do
    expect(subject.compile("<%= hello_world %>", context_helper: test_helper.context_helper)).to eq("hello world")
  end
end