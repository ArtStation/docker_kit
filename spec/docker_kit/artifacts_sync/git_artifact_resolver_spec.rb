RSpec.describe DockerKit::ArtifactsSync::GitArtifactResolver do
  subject{ DockerKit::ArtifactsSync::GitArtifactResolver.new }

  let(:artifact_url) { "git@example.com/myapp.git" }
  let(:artifact) { DockerKit::Core::Artifacts::Git.new(:myapp).setup(remote_url: artifact_url) }

  it "downloads repo if it's not yet cloned" do
    expect(subject.git_commands).to receive(:get_remote_url).and_return(nil)
    expect(subject.git_commands).to receive(:download_repo).with(
      instance_of(TestShell),
      remote_url: artifact_url, 
      path:       artifact.cloned_path, 
      branch:     artifact.branch
    )

    subject.resolve(test_helper.shell, artifact)
  end

  it "pulls repo if it's already cloned" do
    expect(subject.git_commands).to receive(:get_remote_url).and_return(artifact_url)
    expect(subject.git_commands).to receive(:force_pull_repo).with(
      instance_of(TestShell),
      path:   artifact.cloned_path, 
      branch: artifact.branch
    )

    subject.resolve(test_helper.shell, artifact)
  end
end