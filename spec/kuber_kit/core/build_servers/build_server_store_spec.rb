require 'spec_helper'

RSpec.describe KuberKit::Core::BuildServers::BuildServerStore do
  subject{ KuberKit::Core::BuildServers::BuildServerStore.new }

  context "#get" do
    it "returns the build server" do
      build_server = KuberKit::Core::BuildServers::BuildServer.new(:default)
      subject.add(build_server)

      expect(subject.get(:default)).to eq(build_server)
    end

    it "raises error if build server is not found" do
      expect{ subject.get(:default) }.to raise_error(KuberKit::Core::Store::NotFoundError)
    end
  end
end