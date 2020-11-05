require 'spec_helper'

RSpec.describe KuberKit::Core::Store do
  subject{ KuberKit::Core::Store.new(MyTestStoreObject) }
  
  class MyTestStoreObject
    attr_reader :name
    def initialize(name)
      @name = name
    end
  end

  it "creates a store with given objects class" do
    expect(subject.object_class_name).to eq(MyTestStoreObject)
  end

  context "get" do
    it "returns already added objects" do
      subject.add(:item1, MyTestStoreObject.new("item1"))
      subject.add(:item2, MyTestStoreObject.new("item2"))
  
      expect(subject.get(:item1).name).to eq("item1")
      expect(subject.get(:item2).name).to eq("item2")
      expect(subject.size).to eq(2)
    end
  
    it "raises NotFound error if item is not found" do
      expect{ subject.get(:test) }.to raise_error(KuberKit::Core::Store::NotFoundError)
    end
  end

  context "add" do  
    it "doesn't allow adding item twice" do
      subject.add(:item1, MyTestStoreObject.new("item1"))
  
      expect{ subject.add(:item1, MyTestStoreObject.new("item1")) }.to raise_error(KuberKit::Core::Store::AlreadyAddedError)
    end
  
    it "doesn't allow adding incorrect class instance" do
      expect{ subject.add(:item1, 12) }.to raise_error(ArgumentError)
    end
  end

  context "reset!" do
    it "resets the items" do
      subject.add(:item1, MyTestStoreObject.new("item1"))
      subject.reset!

      expect(subject.size).to eq(0)
    end
  end

  context "exists?" do
    it "returns true if object exists" do
      subject.add(:item1, MyTestStoreObject.new("item1"))
      expect(subject.exists?(:item1)).to be true
    end

    it "returns false if object doesn't exist" do
      expect(subject.exists?(:item1)).to be false
    end
  end
end