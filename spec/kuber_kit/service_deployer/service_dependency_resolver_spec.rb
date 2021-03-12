RSpec.describe KuberKit::ServiceDeployer::ServiceDependencyResolver do
  subject{ KuberKit::ServiceDeployer::ServiceDependencyResolver.new }

  let!(:serviceA) { service_helper.store.define(:serviceA).depends_on(:serviceB) }
  let!(:serviceB) { service_helper.store.define(:serviceB).depends_on(:serviceC, :serviceD) }
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
      service_helper.store.define(:service2_a).depends_on(:service1)
      service_helper.store.define(:service2_b).depends_on(:service1)
      service_helper.store.define(:service3_a).depends_on(:service2_a)
      service_helper.store.define(:service3_b).depends_on(:service2_b, :service1)
      service_helper.store.define(:service4).depends_on(:service1, :service3_a, :service3_b)

      callback = Proc.new {}

      expect(callback).to receive(:call).with([:service1])
      expect(callback).to receive(:call).with([:service2_a, :service2_b])
      expect(callback).to receive(:call).with([:service3_a, :service3_b])
      expect(callback).to receive(:call).with([:service4])

      subject.each_with_deps([:service4], &callback)
    end
  end
end