RSpec.describe KuberKit::Shell::SshShell do
  subject{ KuberKit::Shell::SshShell.new }

  let(:ssh_test_dir) { ssh_test_connection[:folder] }
  let(:ssh_fixtures_dir) { File.join(ssh_test_dir, "spec", "fixtures") }

  before do
    subject.connect(
      host: ssh_test_connection[:host], 
      user: ssh_test_connection[:user], 
      port: ssh_test_connection[:port]
    )
  end

  after do
    subject.disconnect
  end

  if ssh_test_connection[:enabled]
    context "#exec!" do
      it "executes given command via ssh and returns result" do
        path = File.join(ssh_fixtures_dir, "shell")
        result = subject.exec!("ls #{path} | grep test.txt")
        expect(result).to eq("test.txt")
      end

      it "raises error if exit status is not 0" do
        path = File.join(ssh_fixtures_dir, "shell")
        expect{
          subject.exec!("cp /some/not/existing/folder /another/not/existing/folder")
        }.to raise_error(KuberKit::Shell::LocalShell::ShellError) 
      end
    end

    context "#upload_file" do
      let(:original_file_path) { File.join(FIXTURES_PATH, "shell", "test.txt") }
      let(:uploaded_file_path) { File.join(ssh_fixtures_dir, "shell", "test.txt.to_be_uploaded") }

      it "writes content of the file" do
        subject.upload_file(original_file_path, uploaded_file_path)

        expect(subject.read(uploaded_file_path)).to eq("test")

        subject.delete(uploaded_file_path)
      end
    end
    
    context "#read" do
      let(:test_file_path) { File.join(ssh_fixtures_dir, "shell", "test.txt") }

      it "reads content of the file" do
        expect(subject.read(test_file_path)).to eq("test")
      end
    end

    context "#write" do
      let(:updating_file_path) { File.join(ssh_fixtures_dir, "shell", "test.subject.delete.txt") }

      it "writes content of the file" do
        subject.write(updating_file_path, %{"test"\r'123'})

        expect(subject.read(updating_file_path)).to eq(%{"test"\r'123'})

        subject.delete(updating_file_path)
      end

      it "overrides content of file if it already exists" do
        subject.write(updating_file_path, "test")
        subject.write(updating_file_path, "test")

        expect(subject.read(updating_file_path)).to eq("test")

        subject.delete(updating_file_path)
      end
    end

    context "#recursive_list_files" do
      let(:test_dir) { File.join(ssh_fixtures_dir, "shell") }

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

      it "re-raises error if different error happens" do
        expect(subject).to receive(:exec!).and_raise(KuberKit::Shell::AbstractShell::ShellError.new("Random error"))

        expect{ subject.recursive_list_files(test_dir) }.to raise_error(KuberKit::Shell::AbstractShell::ShellError)
      end
    end

    context "#disconnect" do
      it "marks shell disconnected" do
        subject.disconnect
        
        expect(subject.connected?).to eq(false)
      end
    end
  end
end