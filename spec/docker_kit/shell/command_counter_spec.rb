RSpec.describe DockerKit::Shell::CommandCounter do
  subject { DockerKit::Shell::CommandCounter.new }

  before { subject.reset! }

  it do
    expect(subject.get_number).to eq(1)

    threads = []
    5.times do
      threads << Thread.new do
        subject.get_number
      end
    end

    threads.each(&:join)

    expect(subject.get_number).to eq(7)
  end
end