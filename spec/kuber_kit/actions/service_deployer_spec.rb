RSpec.describe KuberKit::Actions::ServiceDeployer do
  subject{ KuberKit::Actions::ServiceDeployer.new }

  let(:shell) { test_helper.shell }

  before do
    service_helper.register_service(:identity_app, images: [:identity_image], tags: ["identity"])
    service_helper.register_service(:auth_app, images: [:auth_image], tags: ["auth"], dependencies: [:identity_app])
    service_helper.register_service(:test_auth_app, images: [:auth_image], template_name: :test_service_template, tags: ["auth"])
  end

  it "compiles images & deploys services found by resolver" do
    expect(subject.service_deployer).to receive(:call).with(subject.local_shell, :identity_app)
    expect(subject.service_deployer).to receive(:call).with(subject.local_shell, :auth_app)
    expect(subject.image_compiler).to receive(:call).with([:identity_image, :auth_image], {}).and_return(KuberKit::Actions::ActionResult.new)
    subject.call(services: ["auth_app"], tags: [])
  end

  it "deploys services by tag" do
    expect(subject.service_deployer).to receive(:call).with(subject.local_shell, :identity_app)
    expect(subject.service_deployer).to receive(:call).with(subject.local_shell, :auth_app)
    expect(subject.service_deployer).to receive(:call).with(subject.local_shell, :test_auth_app)
    expect(subject.image_compiler).to receive(:call).with([:identity_image, :auth_image], {}).and_return(KuberKit::Actions::ActionResult.new)
    subject.call(services: [], tags: ["auth"])
  end

  it "skips compilation if such option provided" do
    expect(subject.service_deployer).to receive(:call).with(subject.local_shell, :identity_app)
    expect(subject.service_deployer).to receive(:call).with(subject.local_shell, :auth_app)
    expect(subject.image_compiler).to receive(:call).never
    subject.call(services: ["auth_app"], tags: [], skip_compile: true)
  end

  it "skips specific services if skip_services option is provided" do
    expect(subject.service_deployer).to receive(:call).with(subject.local_shell, :identity_app)
    expect(subject.service_deployer).to receive(:call).with(subject.local_shell, :auth_app)
    expect(subject.image_compiler).to receive(:call).never
    subject.call(services: [], tags: ["auth"], skip_services: ["test_auth_app"], skip_compile: true)
  end

  it "skips dependencies if skip_dependencies option is provided" do
    expect(subject.service_deployer).to receive(:call).with(subject.local_shell, :auth_app)
    expect(subject.service_deployer).to receive(:call).with(subject.local_shell, :test_auth_app)
    expect(subject.image_compiler).to receive(:call).never
    subject.call(services: [], tags: ["auth"], skip_dependencies: true, skip_compile: true)
  end

  it "deploys initial services first" do
    test_helper
      .configuration_store
      .define(:production)
      .initial_services([:identity_app])

    KuberKit.set_configuration_name(:production)

    expect(subject).to receive(:deploy_simultaneously).with([:identity_app], anything)
    expect(subject).to receive(:deploy_simultaneously).with([:auth_app], anything)
    
    expect(subject.image_compiler).to receive(:call).never
    subject.call(services: ["auth_app"], tags: [], skip_dependencies: true, skip_compile: true)
  end

  it "shows deployment options selection if no service found" do
    expect(subject.deployment_options_selector).to receive(:call).and_return([[], ["auth"]])
    expect(subject.image_compiler).to receive(:call).with([:identity_image, :auth_image], {}).and_return(KuberKit::Actions::ActionResult.new)
    expect(subject.service_deployer).to receive(:call).with(subject.local_shell, :identity_app)
    expect(subject.service_deployer).to receive(:call).with(subject.local_shell, :auth_app)
    expect(subject.service_deployer).to receive(:call).with(subject.local_shell, :test_auth_app)
    subject.call(services: [], tags: [])
  end

  it "prints error if error happen" do
    expect(subject.ui).to receive(:print_error)
    expect(subject.image_compiler).to receive(:call).with([:identity_image, :auth_image], {}).and_return(KuberKit::Actions::ActionResult.new)
    allow(subject.service_deployer).to receive(:call).and_raise(KuberKit::Error.new("Some error"))
    subject.call(services: ["auth_app"], tags: [])
  end
end