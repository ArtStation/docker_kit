class KuberKit::Actions::ActionResult
  attr_reader :finished_tasks, :result, :error

  def initialize()
    @results         = {}
    @started_tasks   = []
    @finished_tasks  = []
    @mutex = Mutex.new
  end

  def start_task(task)
    @mutex.synchronize do
      @started_tasks.push(task)
    end
  end

  def finish_task(task, result)
    @mutex.synchronize do
      @started_tasks.delete(task)
      @finished_tasks.push(task)
      @results[task] = result
    end
  end

  def failed!(error)
    @error = error
  end

  def succeeded?
    @error.nil? && @started_tasks.empty?
  end
end