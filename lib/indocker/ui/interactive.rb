require 'cli/ui'

class Indocker::UI::Interactive
  class TaskGroup < CLI::UI::SpinGroup
  end

  def create_task_group
    init_if_needed
    TaskGroup.new
  end

  def create_task(title, &block)
    init_if_needed
    CLI::UI::Spinner.spin(title, &block)
  end

  def print_info(title, text)
    print_in_frame(title, text, color: :blue)
  end

  def print_error(title, text)
    print_in_frame(title, text, color: :red)
  end

  def print_warning(title, text)
    print_in_frame(title, text, color: :yellow)
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