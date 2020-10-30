require 'spec_helper'

RSpec.describe DockerKit::Core::Artifacts::Git do
  subject{ DockerKit::Core::Artifacts::Git.new(:example_artifact) }

  it "returns cloned_path based on artifact_name" do
    expect(subject.cloned_path).to eq("/tmp/docker_kit/artifacts/example_artifact")
  end
end