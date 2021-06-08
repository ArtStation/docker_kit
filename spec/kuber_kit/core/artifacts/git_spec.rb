require 'spec_helper'

RSpec.describe KuberKit::Core::Artifacts::Git do
  subject{ KuberKit::Core::Artifacts::Git.new(:example_artifact) }

  it "returns cloned_path based on artifact_name" do
    expect(subject.cloned_path).to eq(File.expand_path(File.join("~", ".kuber_kit/artifacts/example_artifact")))
  end
end