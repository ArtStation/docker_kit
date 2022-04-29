class KuberKit::ShellLauncher::Strategies::Abstract
  def call(shell, service)
    raise KuberKit::NotImplementedError, "must be implemented"
  end
end