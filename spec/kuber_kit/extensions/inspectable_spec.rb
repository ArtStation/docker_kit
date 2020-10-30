RSpec.describe KuberKit::Extensions::Inspectable do
  class InspectableObject
    include KuberKit::Extensions::Inspectable

    def initialize()
      @name = "Test"
    end
  end

  subject { InspectableObject.new }

  it do
    expect(subject.inspect).to eq(%Q[InspectableObject<{:name=>"Test"}>])
  end
end