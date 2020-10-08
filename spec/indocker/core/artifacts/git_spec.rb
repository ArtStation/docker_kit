require 'spec_helper'

RSpec.describe Indocker::Core::Artifacts::Git do
  subject{ Indocker::Core::Artifacts::Git.new(:example_artifact) }

  it "returns cloned_path based on artifact_name" do
    expect(subject.cloned_path).to eq("/tmp/indocker/artifacts/example_artifact")
  end
end