RSpec.describe Indocker::Shell::LocalShell do
  subject{ Indocker::Shell::LocalShell.new }

  context "#exec!" do
    it "executes given command locally and returns result" do
      path = File.expand_path(__dir__)
      result = subject.exec!("ls #{path} | grep local_shell_spec")
      expect(result).to eq("local_shell_spec.rb")
    end

    it "raises error if exit status is not 0" do
      path = File.expand_path(__dir__)
      expect{
        subject.exec!("cp /some/not/existing/folder /another/not/existing/folder")
      }.to raise_error(Indocker::Shell::LocalShell::ShellError) 
    end
  end
  
  context "#read" do
    let(:test_file_path) { File.join(FIXTURES_PATH, "shell", "test.txt") }

    it "reads content of the file" do
      expect(subject.read(test_file_path)).to eq("test")
    end
  end

  context "#write" do
    let(:updating_file_path) { File.join(FIXTURES_PATH, "shell", "test.txt.to_be_updated") }

    it "writes content of the file" do
      subject.write(updating_file_path, "test")

      expect(File.read(updating_file_path)).to eq("test")

      FileUtils.rm(updating_file_path)
    end
  end

  context "#recursive_list_files" do
    let(:test_dir) { File.join(FIXTURES_PATH, "shell") }

    let(:file_1_path) { File.join(test_dir, "a_folder", "test2.txt") }
    let(:file_2_path) { File.join(test_dir, "test.txt") }

    it "returns list of files in dir" do
      result = subject.recursive_list_files(test_dir)
      
      expect(result.sort).to eq([file_1_path, file_2_path])
    end

    it "returns list of files filtered by name" do
      result = subject.recursive_list_files(test_dir, name: "test2*")
      
      expect(result.sort).to eq([file_1_path])
    end

    it "raises not found error if directory not found" do
      expect(subject).to receive(:exec!).and_raise(Indocker::Shell::AbstractShell::ShellError.new("No such file or directory"))

      expect{ subject.recursive_list_files(test_dir) }.to raise_error(Indocker::Shell::AbstractShell::DirNotFoundError)
    end

    it "reraises error if different error happens" do
      expect(subject).to receive(:exec!).and_raise(Indocker::Shell::AbstractShell::ShellError.new("Random error"))

      expect{ subject.recursive_list_files(test_dir) }.to raise_error(Indocker::Shell::AbstractShell::ShellError)
    end
  end
end