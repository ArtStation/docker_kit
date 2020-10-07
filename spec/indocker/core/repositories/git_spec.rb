require 'spec_helper'

RSpec.describe Indocker::Core::Repositories::Git do
  subject{ Indocker::Core::Repositories::Git.new(:default_repository) }

  it "returns cloned_path based on repository_name" do
    expect(subject.cloned_path).to eq("/tmp/indocker/repositories/default_repository")
  end
end