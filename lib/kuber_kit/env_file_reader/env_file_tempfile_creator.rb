class KuberKit::EnvFileReader::EnvFileTempfileCreator
  include KuberKit::Import[
    "env_file_reader.reader",
    "configs"
  ]

  def call(shell, env_file)
    env_file_hash = reader.read(shell, env_file)
    env_file_raw  = env_file_hash.to_a.map{|k,v| "#{k}=#{v}"}.join("\r\n")
    temp_file_name = env_file.name
    temp_file_path = File.join(configs.env_file_compile_dir, build_id)
  end
end