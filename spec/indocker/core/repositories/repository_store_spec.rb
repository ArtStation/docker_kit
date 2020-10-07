require 'spec_helper'

RSpec.describe Indocker::Core::Repositories::RepositoryStore do
  subject{ Indocker::Core::Repositories::RepositoryStore.new }

  context "#get_global" do
    it "returns global repository" do
      repository = Indocker::Core::Repositories::Git.new(:default)
      subject.add(repository)

      expect(subject.get_global(:default)).to eq(repository)
    end

    it "raises error if repository is not found" do
      expect{ subject.get_global(:default) }.to raise_error(Indocker::Core::Repositories::RepositoryStore::NotFoundError)
    end
  end

  context "#get_from_configuration" do
    it "returns configuration repository" do
      repository = Indocker::Core::Repositories::Git.new(:production_default)
      subject.add(repository)
      test_helper.configuration_store.define(:production).use_repository(:production_default, as: :default)
      Indocker.set_configuration_name(:production)

      expect(subject.get_from_configuration(:default)).to eq(repository)
    end

    it "returns nil if repository is not found" do
      expect(subject.get_from_configuration(:default)).to be_nil
    end
  end

  context "#add" do
    it "doesn't allow adding repository twice" do
      repository = Indocker::Core::Repositories::Git.new(:default)
      subject.add(repository)

      expect{ subject.add(repository) }.to raise_error(Indocker::Core::Repositories::RepositoryStore::AlreadyAddedError)
    end

    it "doesn't allow adding not repository class" do
      expect{ subject.add(12) }.to raise_error(ArgumentError)
    end
  end
end