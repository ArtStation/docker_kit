class KuberKit::UI::Debug < KuberKit::UI::Simple
  def print_info(title, text)
    print_text(text, color: String::Colors::BLUE)
  end

  def print_error(title, text)
    print_text(text, color: String::Colors::RED)
  end

  def print_warning(title, text)
    print_text(text, color: String::Colors::YELLOW)
    logger.debug(text)
  end

  def print_debug(title, text)
    print_text(text, color: nil)
    logger.debug(text)
  end

  protected
    def print_text(text, color: nil)
      colorized_message = color ? text.colorize(color) : text
      puts "  #{Time.now.strftime("%H:%M:%S").grey} #{colorized_message}"
    end
end