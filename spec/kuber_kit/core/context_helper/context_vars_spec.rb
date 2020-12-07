RSpec.describe KuberKit::Core::ContextHelper::ContextVars do
  subject { KuberKit::Core::ContextHelper::ContextVars }

  it "allows reading top level arguments" do
    result = subject.new({foo: "bar"})
    expect(result.foo).to eq("bar")
  end

  it "allows reading multi-level arguments" do
    result = subject.new({foo: {bar: {config: "test"}}})
    expect(result.foo.bar.config).to eq("test")
  end

  it "raises exception if config variable not found" do
    result = subject.new({
      foo: { test: "bar" }
    })
    expect { result.foo.bar }.to raise_error(KuberKit::Error, /build arg \'foo\.bar\' is not defined/)
  end
end