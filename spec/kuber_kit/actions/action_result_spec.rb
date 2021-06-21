RSpec.describe KuberKit::Actions::ActionResult do
  subject{ KuberKit::Actions::ActionResult.new }

  it "is succeeded if nothing is done with result" do
    expect(subject.succeeded?).to eq(true)
  end

  it "is succeeded if tasks finished" do
    subject.start_task(:compile_image)
    subject.finish_task(:compile_image)

    expect(subject.succeeded?).to eq(true)
  end

  it "is not succeeded if there are unfinished tasks" do
    subject.start_task(:compile_image)

    expect(subject.succeeded?).to eq(false)
  end
  
  it "is not succeeded if result is failed" do
    subject.failed!("task was failed")

    expect(subject.succeeded?).to eq(false)
  end

  it "returns results of finished tasks" do
    subject.start_task(:compile_image)
    subject.finish_task(:compile_image, {id: "1"})

    expect(subject.all_results).to eq({compile_image: {id: "1"}})
  end
end