RSpec.describe Indocker::UI::Simple do
  subject{ Indocker::UI::Simple.new }

  it "can create a task group" do
    task_group = subject.create_task_group

    counter = 0
    task_group.add("Do some work") do |task|
      counter += 1

      task.update_title("Done some work")
    end

    task_group.wait

    expect(counter).to eq(1)
  end

  it "can create a single task" do
    counter = 0
    subject.create_task("Do some work") do |task|
      counter += 1

      task.update_title("Done some work")
    end

    expect(counter).to eq(1)
  end
end