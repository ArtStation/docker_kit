require 'logger'
require 'fileutils'

class KuberKit::Tools::LoggerFactory
  SEVERITY_COLORS_BY_LEVEL = {
    Logger::INFO   => String::Colors::GREEN,
    Logger::WARN   => String::Colors::PURPLE,
    Logger::DEBUG  => String::Colors::YELLOW,
    Logger::ERROR  => String::Colors::RED,
    Logger::FATAL  => String::Colors::PURPLE,
  }

  include KuberKit::Import[
    "configs",
  ]

  def create(stdout = nil, level = nil)
    if !stdout
      prepare_log_file(configs.log_file_path)
    end
    
    logger = Logger.new(stdout || configs.log_file_path)

    logger.level = level || Logger::DEBUG

    logger.formatter = proc do |severity, datetime, progname, msg|
      level = Logger::SEV_LABEL.index(severity)

      severity_color = SEVERITY_COLORS_BY_LEVEL[level]

      severity_text  = severity.to_s
      severity_text  = severity_text.colorize(severity_color) if severity_color

      if level == Logger::DEBUG
        "#{datetime.strftime("%Y/%m/%d %H:%M:%S").grey} #{msg}\n"
      else
        "#{datetime.strftime("%Y/%m/%d %H:%M:%S").grey} #{severity_text.downcase}: #{msg}\n"
      end
    end

    logger
  end

  private
    def prepare_log_file(file_path)
      dir_path = File.dirname(file_path)
      unless Dir.exists?(dir_path)
        FileUtils.mkdir_p(dir_path)
      end
      FileUtils.touch(file_path)
    end
end