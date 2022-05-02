RSpec.describe KuberKit::Shell::LocalShell do
  subject{ KuberKit::Shell::LocalShell.new }

  let(:test_dir_path) { File.join(FIXTURES_PATH, "shell") }
  let(:test_file_path) { File.join(FIXTURES_PATH, "shell", "test.txt") }

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
      }.to raise_error(KuberKit::Shell::LocalShell::ShellError) 
    end
  end

  context "#replace!" do
    it "calls exec function with a shell command" do
      expect(subject).to receive(:system_exec).with("$SHELL")
      subject.replace!()
    end

    it "calls exec function with env variables" do
      expect(subject).to receive(:system_exec).with("TEST=value ANOTHER_TEST=another $SHELL")
      subject.replace!(env: ["TEST=value", "ANOTHER_TEST=another"])
    end
  end
  
  context "#read" do
    it "reads content of the file" do
      expect(subject.read(test_file_path)).to eq("test")
    end
  end

  context "#sync" do
    let(:original_file_path) { File.join(FIXTURES_PATH, "shell", "test.txt") }
    let(:uploaded_file_path) { File.join(FIXTURES_PATH, "shell", "test.txt.to_be_uploaded") }

    it "writes content of the file" do
      subject.sync(original_file_path, uploaded_file_path)

      expect(subject.read(uploaded_file_path)).to eq("test")

      subject.delete(uploaded_file_path)
    end
  end

  context "#write" do
    let(:updating_file_path) { File.join(FIXTURES_PATH, "shell", "test.txt.to_be_updated") }

    it "writes content of the file" do
      subject.write(updating_file_path, "test")

      expect(File.read(updating_file_path)).to eq("test")

      subject.delete(updating_file_path)
    end

    it "overrides content of file if it already exists" do
      subject.write(updating_file_path, "test")
      subject.write(updating_file_path, "test")

      expect(File.read(updating_file_path)).to eq("test")

      subject.delete(updating_file_path)
    end
  end

  context "#file_exists?" do
    it "returns true if file exists" do
      expect(subject.file_exists?(test_file_path)).to eq(true)
    end

    it "returns false if it's dir and not file" do
      expect(subject.file_exists?(test_dir_path)).to eq(false)
    end

    it "returns false if file does not exist" do
      expect(subject.file_exists?("/some/not/existing.file")).to eq(false)
    end
  end

  context "#dir_exists?" do
    it "returns true if dir exists" do
      expect(subject.dir_exists?(test_dir_path)).to eq(true)
    end

    it "returns false if it's file and not dir" do
      expect(subject.dir_exists?(test_file_path)).to eq(false)
    end

    it "returns true if file does not exist" do
      expect(subject.dir_exists?("/some/not/existing/dir")).to eq(false)
    end
  end

  context "#expand_path" do
    it "expands a relative path" do
      path = "~/.kuber_kit"
      expanded_path = File.expand_path(path)
      expect(subject.expand_path(path)).to eq(expanded_path)
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
      expect(subject).to receive(:exec!).and_raise(KuberKit::Shell::AbstractShell::ShellError.new("No such file or directory"))

      expect{ subject.recursive_list_files(test_dir) }.to raise_error(KuberKit::Shell::AbstractShell::DirNotFoundError)
    end

    it "reraises error if different error happens" do
      expect(subject).to receive(:exec!).and_raise(KuberKit::Shell::AbstractShell::ShellError.new("Random error"))

      expect{ subject.recursive_list_files(test_dir) }.to raise_error(KuberKit::Shell::AbstractShell::ShellError)
    end
  end
end