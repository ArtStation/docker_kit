RSpec.describe KuberKit::ServiceDeployer::DeploymentOptionsSelector do
  subject{ KuberKit::ServiceDeployer::DeploymentOptionsSelector.new }

  let(:shell) { test_helper.shell }

  before do
    service_helper.register_service(:auth_app, images: [:auth_image], tags: ["auth"])
    service_helper.register_service(:test_auth_app, images: [:auth_image], template_name: :test_service_template, tags: ["auth"])
  end

  it "shows tags selection first" do
    expect(subject.ui).to receive(:prompt).with("Please select which tag to deploy", any_args).and_return("auth")

    expect(subject.call()).to eq([[], ["auth"]])
  end

  it "shows service selection if no tag selected" do
    expect(subject.ui).to receive(:prompt).with("Please select which tag to deploy", any_args).and_return("deploy specific service")
    expect(subject.ui).to receive(:prompt).with("Please select which service to deploy", any_args).and_return("auth_app")

    expect(subject.call()).to eq([["auth_app"], []])
  end

  it "allows deploying all services" do
    expect(subject.ui).to receive(:prompt).with("Please select which tag to deploy", any_args).and_return("deploy all services")

    expect(subject.call()).to eq([["*"], []])
  end
end