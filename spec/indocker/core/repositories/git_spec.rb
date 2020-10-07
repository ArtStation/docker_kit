require 'spec_helper'

RSpec.describe Indocker::Core::Repositories::Git do
  subject{ Indocker::Core::Repositories::Git.new(:default) }

  it "returns project name based on url" do
    subject.setup(remote_url: "git@example.com/myapp.git")

    expect(subject.project_name).to eq("myapp")
  end

  it "returns namespace based on project name and branch" do
    subject.setup(remote_url: "git@example.com/myapp.git", branch: "review")

    expect(subject.namespace).to eq("myapp/review")
  end
end