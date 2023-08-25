require 'spec_helper'

RSpec.describe KuberKit::Core::ConfigurationDefinition do
  subject{ KuberKit::Core::ConfigurationDefinition.new(:production) }

  context "initialize" do
    it "can initialize configuration with symbol name" do
      definition = KuberKit::Core::ConfigurationDefinition.new(:production)
      expect(definition.configuration_name).to eq(:production)
    end

    it "can initialize configuration with string name" do
      definition = KuberKit::Core::ConfigurationDefinition.new("production")
      expect(definition.configuration_name).to eq(:production)
    end
  end

  context "artifact" do
    it "saves artifacts as hash" do
      subject.use_artifact(:main_production_repo, as: :main_repo)

      expect(subject.to_attrs.artifacts).to eq({main_repo: :main_production_repo})
    end

    it "doesn't allow duplicates" do
      subject.use_artifact(:main_production_repo, as: :main_repo)
      expect{
        subject.use_artifact(:main_production_repo, as: :main_repo)
      }.to raise_error(KuberKit::Core::ConfigurationDefinition::ResourceAlreadyAdded)
    end
  end

  context "registry" do
    it "saves registries as hash" do
      subject.use_registry(:main_production_registry, as: :main_registry)

      expect(subject.to_attrs.registries).to eq({main_registry: :main_production_registry})
    end

    it "doesn't allow duplicates" do
      subject.use_registry(:main_production_registry, as: :main_registry)
      expect{
        subject.use_registry(:main_production_registry, as: :main_registry)
      }.to raise_error(KuberKit::Core::ConfigurationDefinition::ResourceAlreadyAdded)
    end
  end

  context "env_file" do
    it "saves env_files as hash" do
      subject.use_env_file(:main_production_env_file, as: :main_registry)

      expect(subject.to_attrs.env_files).to eq({main_registry: :main_production_env_file})
    end

    it "doesn't allow duplicates" do
      subject.use_env_file(:main_production_env_file, as: :main_registry)
      expect{
        subject.use_env_file(:main_production_env_file, as: :main_registry)
      }.to raise_error(KuberKit::Core::ConfigurationDefinition::ResourceAlreadyAdded)
    end
  end

  context "template" do
    it "saves templates as hash" do
      subject.use_template(:main_production_template, as: :main_registry)

      expect(subject.to_attrs.templates).to eq({main_registry: :main_production_template})
    end

    it "doesn't allow duplicates" do
      subject.use_template(:main_production_template, as: :main_registry)
      expect{
        subject.use_template(:main_production_template, as: :main_registry)
      }.to raise_error(KuberKit::Core::ConfigurationDefinition::ResourceAlreadyAdded)
    end
  end

  context "kubeconfig_path" do
    it "sets kubeconfig_path for confuguration" do
      subject.kubeconfig_path("/path/to/kube.cfg")

      expect(subject.to_attrs.kubeconfig_path).to eq("/path/to/kube.cfg")
    end
  end

  context "kubectl_entrypoint" do
    it "sets kubectl_entrypoint for confuguration" do
      subject.kubectl_entrypoint("bash -c \"source /etc/env; $@\"")

      expect(subject.to_attrs.kubectl_entrypoint).to eq("bash -c \"source /etc/env; $@\"")
    end
  end

  context "deployer_namespace" do
    it "sets deployer_namespace for confuguration" do
      subject.deployer_namespace("test")

      expect(subject.to_attrs.deployer_namespace).to eq("test")
    end
  end

  context "deployer_strategy" do
    it "sets deployment strategy confuguration" do
      subject.deployer_strategy(:docker_compose)

      expect(subject.to_attrs.deployer_strategy).to eq(:docker_compose)
    end
  end

  context "deployer_require_confirmation" do
    it "defines attributes for services" do
      subject.deployer_require_confirmation()

      expect(subject.to_attrs.deployer_require_confirmation).to eq(true)
    end
  end

  context "enabled_services" do
    it "appends service to enabled services" do
      subject.enabled_services(service_1: {}, service_2: {})
      subject.enabled_services(service_3: {}, service_4: {})

      expect(subject.to_attrs.enabled_services).to eq([:service_1, :service_2, :service_3, :service_4])
    end

    it "defines attributes for service" do
      subject.enabled_services(my_service: {scale: 1})

      expect(subject.to_attrs.services_attributes[:my_service]).to eq({scale: 1})
    end

    it "allows using array to set enabled services" do
      subject.enabled_services([:service_1, :service_2])
      subject.enabled_services([:service_3])

      expect(subject.to_attrs.enabled_services).to eq([:service_1, :service_2, :service_3])
    end
  end

  context "disabled_services" do
    it "allows using array to set disabled services" do
      subject.disabled_services([:service_1, :service_2])
      subject.disabled_services([:service_3])

      expect(subject.to_attrs.disabled_services).to eq([:service_1, :service_2, :service_3])
    end
  end

  context "default_services" do
    it "allows using array to set default services" do
      subject.default_services([:service_1, :service_2])
      subject.default_services([:service_3])

      expect(subject.to_attrs.default_services).to eq([:service_1, :service_2, :service_3])
    end
  end

  context "initial_services (deprecated)" do
    it "allows using array to set pre-deploy services" do
      subject.initial_services([:service_1, :service_2])
      subject.initial_services([:service_3])

      expect(subject.to_attrs.pre_deploy_services).to eq([:service_1, :service_2, :service_3])
    end
  end

  context "pre_deploy_services" do
    it "allows using array to set pre-deploy services" do
      subject.pre_deploy_services([:service_1, :service_2])
      subject.pre_deploy_services([:service_3])

      expect(subject.to_attrs.pre_deploy_services).to eq([:service_1, :service_2, :service_3])
    end
  end

  context "post_deploy_services" do
    it "allows using array to set post-deploy services" do
      subject.post_deploy_services([:service_1, :service_2])
      subject.post_deploy_services([:service_3])

      expect(subject.to_attrs.post_deploy_services).to eq([:service_1, :service_2, :service_3])
    end
  end

  context "service_attributes" do
    it "defines attributes for services" do
      subject.service_attributes(my_service: {scale: 1})

      expect(subject.to_attrs.services_attributes[:my_service]).to eq({scale: 1})
    end
  end

  context "build server" do
    it "saves build_servers as array" do
      subject.use_build_server(:main_build_server)

      expect(subject.to_attrs.build_servers).to eq([:main_build_server])
    end
  end

  context "global build vars" do
    it "sets global build vars" do
      subject.global_build_vars({
        rails_app: {
          compile_assets: true
        }
      })

      expect(subject.to_attrs.global_build_vars).to eq({
        rails_app: {
          compile_assets: true
        }
      })
    end
  end
end