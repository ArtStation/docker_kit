class Indocker::Preprocessing::FilePreprocessor
  include Indocker::Import["preprocessing.text_preprocessor"]

  PreprocessingError = Class.new(Indocker::Error)

  def compile(shell, source_path, destination_path: nil, context_helper: nil)
    destination_path ||= source_path

    prepare_destination_dir(destination_path)

    template = shell.read(source_path)
    content = text_preprocessor.compile(template, context_helper: context_helper)

    is_content_changed = template != content
    if !is_content_changed && source_path == destination_path
      return false
    end

    shell.write(destination_path, content)

    return true
  rescue Exception => e
    message = "#{e.message}\r\n"
    message += e.backtrace.select{|l| l.include?("(erb)") }.join("\r\n")
    raise PreprocessingError, "Error while processing template #{source_path}.\r\n#{message}"
  end

  def prepare_destination_dir(destination_path)
    FileUtils.mkdir_p(File.dirname(destination_path))
  end
end