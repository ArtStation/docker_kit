class TestShell < DockerKit::Shell::LocalShell
  def exec!(command)
    return true
  end

  def recursive_list_files(path)
    return []
  end
end