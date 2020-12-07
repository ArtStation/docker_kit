RSpec.describe KuberKit::Configs do
  subject{ KuberKit::Configs.new }

  it "allows setting config variable" do
    subject.image_tag = "foobar"
    expect(subject.get(:image_tag)).to eq("foobar")
  end

  it "doesn't allow setting unknown config" do
    expect{ subject.set("foo", "bar") }.to raise_error(ArgumentError)
  end
end