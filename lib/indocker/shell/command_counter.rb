class Indocker::Shell::CommandCounter
  def initialize
    @mutex = Mutex.new
  end

  def get_number
    @mutex.synchronize do
      @@number ||= 0
      @@number += 1
      @@number
    end
  end
end