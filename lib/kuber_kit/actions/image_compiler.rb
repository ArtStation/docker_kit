class KuberKit::Actions::ImageCompiler
  include KuberKit::Import[
    "image_compiler.image_dependency_resolver",
    "image_compiler.build_server_pool_factory",
    "shell.local_shell",
    "configs",
    "ui",
    image_compiler: "image_compiler.action_handler",
  ]

  Contract ArrayOf[Symbol], Hash => Any
  def call(image_names, options)
    build_id = generate_build_id
    build_server_pool = build_server_pool_factory.create()

    compiled_images = []
    compilation_result = {}
    image_dependency_resolver.each_with_deps(image_names) do |dep_image_names|
      ui.print_debug("ImageCompiler", "Scheduling to compile: #{dep_image_names.inspect}. Limit: #{configs.compile_simultaneous_limit}")
      result = compile_simultaneously(dep_image_names, build_id, build_server_pool)
      compiled_images += dep_image_names
      compilation_result = compilation_result.merge(result)
    end

    build_server_pool.disconnect_all

    { images: compiled_images, compilation: compilation_result }
  rescue KuberKit::Error => e
    ui.print_error("Error", e.message)

    false
  end

  private
    def compile_simultaneously(image_names, build_id, build_server_pool)
      task_group = ui.create_task_group
      compiler_result = {}
      image_names.map do |image_name|

        ui.print_debug("ImageCompiler", "Started compiling: #{image_name.to_s.green}")
        task_group.add("Compiling #{image_name.to_s.yellow}") do |task|
          shell = build_server_pool.get_shell
          
          compiler_result[image_name] = image_compiler.call(shell, image_name, build_id)

          task.update_title("Compiled #{image_name.to_s.green}")
          ui.print_debug("ImageCompiler", "Finished compiling: #{image_name}")
        end
        
      end
      task_group.wait
      compiler_result
    end

    def generate_build_id
      Time.now.strftime("%H%M%S")
    end
end