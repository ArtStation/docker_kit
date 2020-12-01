require 'spec_helper'

RSpec.describe KuberKit::Core::ServiceDefinition do
  subject{ KuberKit::Core::ServiceDefinition.new(:example_service) }

  context "initialize" do
    it "can initialize service with symbol name" do
      definition = KuberKit::Core::ServiceDefinition.new(:example_service)
      expect(definition.service_name).to eq(:example_service)
    end

    it "can initialize service with string name" do
      definition = KuberKit::Core::ServiceDefinition.new("example_service")
      expect(definition.service_name).to eq(:example_service)
    end
  end

  context "template" do
    it "sets service template name with symbol" do
      definition = subject.template(:service_template)
  
      expect(definition.to_service_attrs.template_name).to eq(:service_template)
    end

    it "sets service template with proc" do
      definition = subject.template{ :service_template }
  
      expect(definition.to_service_attrs.template_name).to eq(:service_template)
    end
  end

  context "tags" do
    it "sets tags with multiple arguments" do
      definition = subject.tags("some_tag", "another_tag")
  
      expect(definition.to_service_attrs.tags).to eq([:some_tag, :another_tag])
    end

    it "sets tags with array of symbols" do
      definition = subject.tags([:some_tag])
  
      expect(definition.to_service_attrs.tags).to eq([:some_tag])
    end

    it "sets tags with proc" do
      definition = subject.tags{ [:some_tag] }
  
      expect(definition.to_service_attrs.tags).to eq([:some_tag])
    end
  end

  context "images" do
    it "sets images with multiple arguments" do
      definition = subject.images("some_image", "another_image")
  
      expect(definition.to_service_attrs.images).to eq([:some_image, :another_image])
    end

    it "sets images with array of symbols" do
      definition = subject.images([:some_image])
  
      expect(definition.to_service_attrs.images).to eq([:some_image])
    end

    it "sets images with proc" do
      definition = subject.images{ [:some_image] }
  
      expect(definition.to_service_attrs.images).to eq([:some_image])
    end
  end

  context "attributes" do
    it "sets attributes with hash" do
      definition = subject.attributes({scale: 2})
  
      expect(definition.to_service_attrs.attributes).to eq({scale: 2})
    end

    it "sets attributes with proc" do
      definition = subject.attributes{ {scale: 2} }
  
      expect(definition.to_service_attrs.attributes).to eq({scale: 2})
    end
  end

  context "deploy_strategy" do
    it "sets deploy strategy with symbol" do
      definition = subject.deploy_strategy(:kubernetes_runner)
  
      expect(definition.to_service_attrs.deploy_strategy).to eq(:kubernetes_runner)
    end

    it "sets deploy strategy with proc" do
      definition = subject.deploy_strategy{ :kubernetes_runner }
  
      expect(definition.to_service_attrs.deploy_strategy).to eq(:kubernetes_runner)
    end
  end
end