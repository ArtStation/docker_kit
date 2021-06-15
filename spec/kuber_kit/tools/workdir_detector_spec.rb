RSpec.describe KuberKit::Tools::WorkdirDetector do
  subject{ KuberKit::Tools::WorkdirDetector.new }

  it do
    expect(subject.call(path: "/kit/path")).to eq("/kit/path")
  end

  it do
    expect(subject.call({})).to eq(File.join(Dir.pwd, "kuber_kit"))
  end

  it do
    expect(subject.call({}, current_dir: "/data")).to eq("/data/kuber_kit")
  end

  it do
    subject.file_presence_checker.lost_path!("/data/my_project/core/blogging/kuber_kit")
    subject.file_presence_checker.lost_path!("/data/my_project/core/kuber_kit")

    expect(subject.call({}, current_dir: "/data/my_project/core/blogging")).to eq("/data/my_project/kuber_kit")
  end

  it do
    subject.file_presence_checker.lost_path!("/data/my_project/kuber_kit")
    subject.file_presence_checker.lost_path!("/data/kuber_kit")

    expect(subject.call({}, current_dir: "/data/my_project")).to eq("/data/my_project/kuber_kit")
  end
end