class Indocker::UI
  def spin(title, &block)
    CLI::UI::Spinner.spin(title, &block)
  end
end