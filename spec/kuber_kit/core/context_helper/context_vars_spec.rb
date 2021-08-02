RSpec.describe KuberKit::Core::ContextHelper::ContextVars do
  subject { KuberKit::Core::ContextHelper::ContextVars }

  context "read as undefined method" do
    it "allows reading top level arguments" do
      result = subject.new({foo: "bar"})
      expect(result.foo).to eq("bar")
    end
  
    it "allows reading multi-level arguments" do
      result = subject.new({foo: {bar: {config: "test"}}})
      expect(result.foo.bar.config).to eq("test")
    end
  
    it "allows getting a hash value" do
      result = subject.new({foo: {bar: {config: "test"}}})
      expect(result.foo.bar.to_h).to eq({config: "test"})
    end
  
    it "raises exception if config variable not found" do
      result = subject.new({
        foo: { test: "bar" }
      })
      expect { result.foo.bar }.to raise_error(KuberKit::Core::ContextHelper::ContextVars::BuildArgUndefined, /build arg \'foo\.bar\' is not defined/)
    end
  end

  context "#read" do
    it "allows reading top level arguments" do
      result = subject.new({foo: "bar"})
      expect(result.read(:foo)).to eq("bar")
    end

    it "allows reading multi-level arguments" do
      result = subject.new({foo: {bar: {config: "test"}}})
      expect(result.read(:foo, :bar, :config)).to eq("test")
    end
  end
  
  context "#variable_defined?" do
    it "returns true if variable is defined" do
      context = subject.new({foo: {bar: {config: "test"}}})
      expect(context.variable_defined?(:foo)).to eq(true)
    end

    it "returns false if variable is not defined" do
      context = subject.new({foo: {bar: {config: "test"}}})
      expect(context.variable_defined?(:foobar)).to eq(false)
    end

    it "allows checking multi-level arguments" do
      result = subject.new({foo: {bar: {config: "test"}}})
      expect(result.variable_defined?(:foo, :bar, :config)).to eq(true)
    end
  end
end