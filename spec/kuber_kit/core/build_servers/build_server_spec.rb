RSpec.describe KuberKit::Core::BuildServers::BuildServer do
  subject { KuberKit::Core::BuildServers::BuildServer.new(:default) }

  context "when server has been setup" do 
    before do
      subject.setup(user: "root", host: "example.com", port: 22)
    end

    it do
      expect(subject.host).to eq("example.com")
    end
  
    it do
      expect(subject.user).to eq("root")
    end
  
    it do
      expect(subject.port).to eq(22)
    end
  end

  context "when server was not setup" do 
    it do
      expect{ subject.host }.to raise_error(ArgumentError)
    end
  
    it do
      expect{ subject.port }.to raise_error(ArgumentError)
    end
  
    it do
      expect{ subject.user }.to raise_error(ArgumentError)
    end
  end
end