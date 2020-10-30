require 'fileutils'

RSpec.describe DockerKit::Preprocessing::FilePreprocessor do
  subject{ DockerKit::Preprocessing::FilePreprocessor.new }
  
  let(:source_path) { File.join(FIXTURES_PATH, "compiler", "erb_template.txt") }
  let(:destination_path) { File.join(FIXTURES_PATH, "compiler", "erb_template.txt.compiled") }
  let(:shell) { test_helper.shell }
  
  after { FileUtils.rm(destination_path) if File.exists?(destination_path) }

  it "compiles a given erb template" do
    subject.compile(shell, source_path, destination_path: destination_path, context_helper: test_helper.context_helper)

    content = File.read(destination_path)
    expect(content).to eq(%{hello world\ntest})
  end

  it "raises PreprocessingError on any error in preprocessing" do
    expect(subject.text_preprocessor).to receive(:compile){ raise SyntaxError }

    expect{ 
      subject.compile(shell, source_path, destination_path: destination_path, context_helper: test_helper.context_helper) 
    }.to raise_error(DockerKit::Preprocessing::FilePreprocessor::PreprocessingError)
  end

  context "destination_path is not provided" do
    it "updates file by source path" do
      FileUtils.cp(source_path, destination_path)
  
      subject.compile(shell, destination_path, context_helper: test_helper.context_helper)
  
      content = File.read(destination_path)
      expect(content).to eq(%{hello world\ntest})
    end
  
    it "doesn't update code if compiled content is not changed" do
      source_path = File.join(FIXTURES_PATH, "compiler", "test.txt")
      
      expect(shell).to receive(:write).never
      subject.compile(shell, source_path)
    end
  end

  context "destination_path has subdir" do
    let(:destination_path) { File.join(FIXTURES_PATH, "compiler", "configs", "erb_template.txt.compiled") }

    it "compiles a given erb template" do
      subject.compile(shell, source_path, destination_path: destination_path, context_helper: test_helper.context_helper)
  
      content = File.read(destination_path)
      expect(content).to eq(%{hello world\ntest})

      FileUtils.rm_r(File.dirname(destination_path))
    end
  end
end