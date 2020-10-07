require 'spec_helper'

RSpec.describe Indocker::Core::Repositories::Local do
  subject{ Indocker::Core::Repositories::Local.new(:default_repository) }

  it "returns cloned_path based on root path" do
    subject.setup("/data/myapp")
    expect(subject.cloned_path).to eq("/data/myapp")
  end
end