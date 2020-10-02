require 'logger'

class Indocker::Tools::LoggerFactory
  def create(stdout, level = nil)
    logger = Logger.new(stdout)

    logger.level = level || Logger::DEBUG

    logger.formatter = proc do |severity, datetime, progname, msg|
      level = Logger::SEV_LABEL.index(severity)

      severity = case level
      when Logger::INFO
        severity.green
      when Logger::WARN
        severity.purple
      when Logger::DEBUG
        severity.yellow
      when Logger::ERROR
        severity.red
      when Logger::FATAL
        severity.red
      else
        severity
      end

      "#{datetime.strftime("%Y/%m/%d %H:%M:%S")} #{severity.downcase}: #{msg}\n"
    end

    logger
  end
end