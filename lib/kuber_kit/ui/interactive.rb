require 'cli/ui'
require "tty-prompt"
require "tty-spinner"

class TTY::Spinner
  def update_title(title)
    success
  end
end

class KuberKit::UI::Interactive
  include KuberKit::Import[
    "tools.logger",
  ]

  class TaskGroup
    attr_reader :spinners

    def initialize(title = "")
      @spinners = []
    end

    def add(title, &block)
      spinner = TTY::Spinner.new("[:spinner] #{title}", format: :dots_6)
      spinner.job(&block)
      @spinners << spinner
    end

    def wait
      jobs = []
      @spinners.each do |spinner|
        if spinner.job?
          spinner.auto_spin
          jobs << Thread.new { spinner.execute_job }
        end
      end
      jobs.each(&:join)
    end
  end

  def create_task_group(title = "")
    TaskGroup.new(title)
  end

  def create_task(title, &block)
    spinner = TTY::Spinner.new("[:spinner] #{title}", format: :dots_6)
    spinner.run(&block)
  end

  def print_info(title, text)
    print_in_frame(title, text, color: :blue)
  end

  def print_error(title, text)
    print_in_frame(title, text, color: :red)
  end

  def print_warning(title, text)
    print_in_frame(title, text, color: :yellow)
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
    prompt = TTY::Prompt.new
    prompt.select(text, options, filter: true)
  end

  private
    def init
      @initialized = true
      ::CLI::UI::StdoutRouter.enable
    end

    def init_if_needed
      init unless @initialized
    end

    def print_in_frame(title, text, color:)
      CLI::UI::Frame.open(title, color: color) do
        puts text
      end
    end
end