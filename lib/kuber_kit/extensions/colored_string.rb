class String
  module Colors
    RED    = 31
    GREEN  = 32
    YELLOW = 33
    BLUE   = 34
    PURPLE = 35
    CYAN   = 36
    GREY   = 37
  end

  def red
    colorize(Colors::RED)
  end

  def green
    colorize(Colors::GREEN)
  end

  def yellow
    colorize(Colors::YELLOW)
  end

  def blue
    colorize(Colors::BLUE)
  end

  def purple
    colorize(Colors::PURPLE)
  end

  def cyan
    colorize(Colors::CYAN)
  end

  def grey
    colorize(Colors::GREY)
  end

  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end
end
