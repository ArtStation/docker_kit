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

  private
    def init
      @initialized = true
      ::CLI::UI::StdoutRouter.enable
    end

    def init_if_needed
      init unless @initialized
    end
end