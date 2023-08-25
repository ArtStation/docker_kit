RSpec.describe KuberKit::ServiceDeployer::ServiceDependencyResolver do
  subject{ KuberKit::ServiceDeployer::ServiceDependencyResolver.new }

  let!(:serviceA) { service_helper.store.define(:serviceA).initialize_with(:serviceB) }
  let!(:serviceB) { service_helper.store.define(:serviceB).initialize_with(:serviceC, :serviceD) }
  let!(:serviceC) { service_helper.store.define(:serviceC) }
  let!(:serviceD) { service_helper.store.define(:serviceD) }

  context "#get_deps" do
    it "returns service dependencies" do
      expect(subject.get_deps(:serviceA)).to eq([:serviceB])
    end
  end

  context "#each_with_deps" do
    it "iterates over dependencies and service itself" do
      service_helper.store.define(:service1)
      service_helper.store.define(:service2_a).initialize_with(:service1)
      service_helper.store.define(:service2_b).initialize_with(:service1)
      service_helper.store.define(:service3_a).initialize_with(:service2_a)
      service_helper.store.define(:service3_b).initialize_with(:service2_b, :service1)
      service_helper.store.define(:service4).initialize_with(:service1, :service3_a, :service3_b)

      callback = Proc.new {}

      expect(callback).to receive(:call).with([:service1])
      expect(callback).to receive(:call).with([:service2_a, :service2_b])
      expect(callback).to receive(:call).with([:service3_a, :service3_b])
      expect(callback).to receive(:call).with([:service4])

      subject.each_with_deps([:service4], &callback)
    end
  end

  context "#get_all_deps" do
    it "returns all dependencies" do
      service_helper.store.define(:service1)
      service_helper.store.define(:service2_a).initialize_with(:service1)
      service_helper.store.define(:service2_b).initialize_with(:service1)
      service_helper.store.define(:service3_a).initialize_with(:service2_a)
      service_helper.store.define(:service3_b).initialize_with(:service2_b, :service1)
      service_helper.store.define(:service4).initialize_with(:service1, :service3_a, :service3_b)

      result = subject.get_all_deps([:service4])
      expect(result.sort).to eq([:service1, :service2_a, :service2_b, :service3_a, :service3_b])
    end
  end
end