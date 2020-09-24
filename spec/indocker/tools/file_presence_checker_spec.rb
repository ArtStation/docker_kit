RSpec.describe Indocker::Tools::FilePresenceChecker do
  subject{ Indocker::Tools::FilePresenceChecker.new }

  it "raises error if file is not found" do
    expect{ subject.check_file!("not_existing_file.rb") }.to raise_error(Indocker::Tools::FilePresenceChecker::FileNotFound)
  end

  it "raises error if dir is not found" do
    expect{ subject.check_file!("/not_existing_dir") }.to raise_error(Indocker::Tools::FilePresenceChecker::FileNotFound)
  end

  it "returns true if file exists" do
    path = File.expand_path(__FILE__)
    expect(subject.check_file!(path)).to be(true)
  end

  it "returns true if file exists" do
    path = File.expand_path(__dir__)
    expect(subject.check_dir!(path)).to be(true)
  end
end