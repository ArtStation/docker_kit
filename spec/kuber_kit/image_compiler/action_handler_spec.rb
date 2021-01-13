RSpec.describe KuberKit::ImageCompiler::ActionHandler do
  subject{ KuberKit::ImageCompiler::ActionHandler.new }

  let(:image) { test_helper.image(:example) }
  let(:shell) { test_helper.shell }

  it "runs image compile by image name and returns compilation result" do
    expect(subject.image_store).to receive(:get_image).with(:example).and_return(image)
    expect(subject.compiler).to receive(:compile).with(shell, image, "/tmp/kuber_kit/image_builds/2020").and_return("image_id")

    result = subject.call(shell, :example, "2020")
    expect(result).to eq("image_id")
  end
end