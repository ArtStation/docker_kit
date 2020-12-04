RSpec.describe KuberKit::Configs::Config do
  subject{ KuberKit::Configs::Config.new }

  it "returns default value if custom value not set" do
    expect(subject.image_dockerfile_name).to eq("Dockerfile")
  end

  it "returns custom value if it's set" do
    KuberKit::Container['configs.config_store'].set("image_dockerfile_name", "Test")
    expect(subject.image_dockerfile_name).to eq("Test")
  end
end