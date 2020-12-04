RSpec.describe KuberKit::Configs::ConfigStore do
  subject{ KuberKit::Configs::ConfigStore.new }

  it "allows setting config variable" do
    subject.set("foo", "bar")
    expect(subject.get("foo")).to eq("bar")
  end
end