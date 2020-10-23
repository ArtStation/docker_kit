class Indocker::Core::Service
  attr_reader :name

  Contract KeywordArgs[
    name:               Symbol,
  ] => Any
  def initialize(name:)
    @name = name
  end
end