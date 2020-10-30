RSpec.describe KuberKit::UI::Interactive do
  subject{ KuberKit::UI::Interactive.new }

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

  it "can print info message" do
    expect(subject).to receive(:print_in_frame)
    subject.print_info("some title", 'some text')
  end

  it "can print info message" do
    expect(subject).to receive(:print_in_frame)
    subject.print_error("some title", 'some text')
  end

  it "can print info message" do
    expect(subject).to receive(:print_in_frame)
    subject.print_warning("some title", 'some text')
  end
end