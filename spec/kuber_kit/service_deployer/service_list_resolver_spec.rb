RSpec.describe KuberKit::ServiceDeployer::ServiceListResolver do
  subject{ KuberKit::ServiceDeployer::ServiceListResolver.new }

  before do
    test_helper.service_store.define("auth_app").tags("web", "auth")
    test_helper.service_store.define("marketplace_app").tags("web", "marketplace")
  end

  context "resolve" do
    it "finds service with services option" do
      result = subject.resolve(services: ["auth_app"])
      expect(result).to eq(["auth_app"])
    end
  
    it "finds service with tags option" do
      result = subject.resolve(tags: ["web"])
      expect(result).to eq(["auth_app", "marketplace_app"])
    end

    it "finds service with wildcard in name" do
      result = subject.resolve(services: ["auth*"])
      expect(result).to eq(["auth_app"])
    end

    it "finds service with wildcard in tag" do
      result = subject.resolve(tags: ["au*"])
      expect(result).to eq(["auth_app"])
    end
  
    it "exludes service with minus in name" do
      result = subject.resolve(tags: ["web"], services: ["-auth_app"])
      expect(result).to eq(["marketplace_app"])
    end

    it "exludes service with wildcard in name" do
      result = subject.resolve(tags: ["web"], services: ["-auth_*"])
      expect(result).to eq(["marketplace_app"])
    end

    it "exludes service with minus in tag" do
      result = subject.resolve(tags: ["web", "-marketplace"])
      expect(result).to eq(["auth_app"])
    end

    it "excludes service with wildcard in tag" do
      result = subject.resolve(tags: ["web", "-au*"])
      expect(result).to eq(["marketplace_app"])
    end
  end

  context "split_by_inclusion" do
    it do
      result = subject.split_by_inclusion(["-foo", "web"])
      expect(result[0]).to eq(["web"])
      expect(result[1]).to eq(["foo"])
    end
  end

  context "matches_name?" do
    it do
      expect(subject.matches_name?("auth_app", "auth_app")).to eq(true)
    end

    it do
      expect(subject.matches_name?("auth_app", "auth_apps")).to eq(false)
    end

    it do
      expect(subject.matches_name?("auth_app", "app")).to eq(false)
    end

    it do
      expect(subject.matches_name?("auth_app", "auth*")).to eq(true)
    end

    it do
      expect(subject.matches_name?("auth_app", "*_app")).to eq(true)
    end

    it do
      expect(subject.matches_name?("auth", "auth*")).to eq(false)
    end

    it do
      expect(subject.matches_name?("aut", "auth*")).to eq(false)
    end

    it do
      expect(subject.matches_name?("auth_app", "app*")).to eq(false)
    end

    it do
      expect(subject.matches_name?("auth_app_1", "*_app_*")).to eq(true)
    end
  end
end