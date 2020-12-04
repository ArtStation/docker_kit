RSpec.describe KuberKit::TemplateReader::Reader do
  subject{ KuberKit::TemplateReader::Reader.new }

  class ExampleTemplateReader < KuberKit::TemplateReader::Strategies::Abstract
    def read(shell, template, context_helper: nil)
      return {name: template.name}
    end
  end

  class ExampleTemplate1 < KuberKit::Core::Templates::AbstractTemplate
  end

  class ExampleTemplate2 < KuberKit::Core::Templates::AbstractTemplate
  end

  let(:reader1) { ExampleTemplateReader.new }
  let(:reader2) { ExampleTemplateReader.new }
  let(:template1) { ExampleTemplate1.new(:template1) }
  let(:template2) { ExampleTemplate2.new(:template2) }

  it "calls the reader for this env file type on read" do
    subject.use_reader(reader1, template_class: ExampleTemplate1)
    subject.use_reader(reader2, template_class: ExampleTemplate2)

    result1 = subject.read(test_helper.shell, template1)
    result2 = subject.read(test_helper.shell, template2)

    expect(result1[:name]).to eq(:template1)
    expect(result2[:name]).to eq(:template2)
  end

  it "raises error if reader not found for class" do
    expect {
      subject.read(test_helper.shell, template1)
    }.to raise_error(KuberKit::TemplateReader::Reader::ReaderNotFoundError)
  end

  it "raises an error if reader is not an instance of abstract reader" do
    expect {
      subject.use_reader(KuberKit, artifact_class: ExampleArtifact1)
    }.to raise_error(ArgumentError)
  end
end