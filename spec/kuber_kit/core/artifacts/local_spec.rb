require 'spec_helper'

RSpec.describe KuberKit::Core::Artifacts::Local do
  subject{ KuberKit::Core::Artifacts::Local.new(:default_repository) }

  it "returns cloned_path based on root path" do
    subject.setup("/data/myapp")
    expect(subject.cloned_path).to eq("/data/myapp")
  end
end