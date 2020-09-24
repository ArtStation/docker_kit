class Indocker::Shell::LocalShell
  def exec!(command)
    result = 
    IO.popen(command, err: [:child, :out]) do |io|
      result = io.read.chomp.strip
    end

    result
  end
end