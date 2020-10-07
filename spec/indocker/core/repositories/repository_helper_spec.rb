require 'spec_helper'

RSpec.describe Indocker::Core::Repositories::RepositoryHelper do
  subject{ Indocker::Core::Repositories::RepositoryHelper.new }
  
  let(:repo) { Indocker::Core::Repositories::Git.new(:default) }

  it "returns namespace based on project name and branch" do
    repo.setup(remote_url: "git@example.com/myapp.git", branch: "review")

    expect(subject.clone_path(repo)).to eq("/tmp/default/repositories/myapp/review")
  end
end