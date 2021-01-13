require 'json'
class KuberKit::UI::Api < KuberKit::UI::Simple
  class Task < KuberKit::UI::Simple::Task
    def print_started
      # do nothing, api formatter should only show result
    end

    def print_finished
      # do nothing, api formatter should only show result
    end
  end

  def create_task_group
    TaskGroup.new(KuberKit::UI::Api::Task)
  end

  def create_task(title, &block)
    task = KuberKit::UI::Api::Task.new(title, &block)
    task.execute
    task.wait
  end

  def print_info(title, text)
    logger.debug(text)
  end

  def print_error(title, text)
    logger.debug(text)
    print_json({error: text})
  end

  def print_warning(title, text)
    logger.debug(text)
  end

  def print_debug(title, text)
    logger.debug(text)
  end

  def print_result(message, data = {})
    print_json({message: message}.merge(data))
  end

  protected
    def print_json(data)
      puts JSON.generate(data)
    end
end