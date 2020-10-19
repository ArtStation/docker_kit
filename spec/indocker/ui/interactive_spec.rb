RSpec.describe Indocker::UI::Interactive do
  subject{ Indocker::UI::Interactive.new }

  it "can create a task group" do
    task_group = subject.create_task_group

    counter = 0
    task_group.add("Do some work") do |task|
      counter += 1
    end

    task_group.wait

    expect(counter).to eq(1)
  end
end