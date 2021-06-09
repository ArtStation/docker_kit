class KuberKit::EnvFileReader::EnvFileTempfileCreator
  include KuberKit::Import[
    "env_file_reader.reader",
    "configs"
  ]

  Contract KuberKit::Shell::AbstractShell, KuberKit::Core::EnvFiles::AbstractEnvFile => String
  def call(shell, env_file)
    env_file_hash = reader.read(shell, env_file)
    env_file_raw  = env_file_hash.to_a.map{|k,v| "#{k}=#{v}"}.join("\r\n")
    temp_file_path = File.join(configs.env_file_compile_dir, env_file.uniq_name)

    shell.write(temp_file_path, env_file_raw)

    temp_file_path
  end
end