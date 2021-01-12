class KuberKit::UI::Simple
  include KuberKit::Import[
    "tools.logger",
  ]

  class Task
    def initialize(title, &callback)
      @title = title
      @callback = callback
    end

    def execute
      if @thread
        raise "Already started execution of task '#{title}'"
      end

      @thread = Thread.new do
        puts "- #{@title.green}"
        @callback.call(self)
        puts "- #{@title.grey}"
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
    def add(task_title, &task_block)
      task = Task.new(task_title, &task_block)
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
    TaskGroup.new
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

  def prompt(text, options, &callback)
    print_info("Select", text)
    result = $stdin.gets.chomp
    callback.call(result) if callback
    result
  end

  private
    def print_text(title, text, color:)
      puts "#{title.colorize(color)}\r\n #{text.colorize(color)}"
    end
end