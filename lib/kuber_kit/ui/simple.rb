class KuberKit::UI::Simple
  include KuberKit::Import[
    "tools.logger",
  ]

  class Task
    def initialize(title, &callback)
      @title = title
      @callback = callback
    end

    def print_started
      puts "- #{@title}"
    end

    def print_finished
      puts "- #{@title.grey}"
    end

    def execute
      if @thread
        raise "Already started execution of task '#{title}'"
      end

      @thread = Thread.new do
        Thread.current.abort_on_exception = true
        Thread.current.report_on_exception = false
        print_started
        @callback.call(self)
        print_finished
      end
    end

    def wait
      if !@thread
        raise "Task '#{title}' not started"
      end
      @thread.join
    end
    
    def update_title(title)
      @title = title
    end
  end

  class TaskGroup
    def initialize(task_class)
      @task_class = task_class
    end

    def add(task_title, &task_block)
      task = @task_class.new(task_title, &task_block)
      task.execute
      add_task(task)
    end

    def add_task(task)
      @tasks ||= []
      @tasks << task
    end

    def wait
      @tasks.each(&:wait)
    end
  end

  def create_task_group
    TaskGroup.new(KuberKit::UI::Simple::Task)
  end

  def create_task(title, &block)
    task = Task.new(title, &block)
    task.execute
    task.wait
  end

  def print_info(title, text)
    print_text(title, text, color: String::Colors::BLUE)
  end

  def print_error(title, text)
    print_text(title, text, color: String::Colors::RED)
  end

  def print_warning(title, text)
    print_text(title, text, color: String::Colors::YELLOW)
    logger.debug(text)
  end

  def print_debug(title, text)
    logger.debug(text)
  end

  def print_result(message, data = {})
    print_debug("Result", "---------------------------")
    print_debug("Result", message)
    print_debug("Result", "---------------------------")
  end

  def prompt(text, options)
    print_info("Select", text + "(#{options.join(', ')})")
    result = $stdin.gets.chomp
    result
  end

  protected
    def print_text(title, text, color:)
      puts "#{title.colorize(color)}\r\n #{text.colorize(color)}"
    end
end