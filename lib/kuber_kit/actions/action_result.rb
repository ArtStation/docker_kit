class KuberKit::Actions::ActionResult
  attr_reader :finished_tasks, :all_results, :error

  def initialize()
    @all_results     = {}
    @started_tasks   = []
    @finished_tasks  = []
    @mutex = Mutex.new
  end

  def start_task(task)
    @mutex.synchronize do
      @started_tasks.push(task)
    end
  end

  def finish_task(task, result = nil)
    @mutex.synchronize do
      @started_tasks.delete(task)
      @finished_tasks.push(task)
      @all_results[task] = result
    end
  end

  def failed!(error)
    @error = error
  end

  def succeeded?
    @error.nil? && @started_tasks.empty?
  end
end