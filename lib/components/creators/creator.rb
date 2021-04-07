require 'fileutils'
require 'xcodeproj'
require_relative './../generate/generator.rb'
require_relative './../../constants/path.rb'
require_relative './../../config/config.rb'

# Creator ...
class Creator
    @@architect_context = ""
    @@feature_context = ""
    
    def initialize(architect_context, feature_context)
        @architect_context = architect_context
        @feature_context = feature_context
    end

    def excute
        
        project_path = Configuration.instance.get_project_path()

        context_folder = "#{project_path}/#{@feature_context}"

        model_path = "#{context_folder}/Model"
        view_model_path = "#{context_folder}/ViewModel"
        service_path = "#{context_folder}/Service"

        model_file_path = "#{model_path}/#{@feature_context}Entity#{PATH::SWIFT_EXTENSION}"
        viewmodel_file_path = "#{view_model_path}/#{@feature_context}ViewModel#{PATH::SWIFT_EXTENSION}"
        service_file_path = "#{service_path}/#{@feature_context}Service#{PATH::SWIFT_EXTENSION}"

        # create if it's not exist
        prepare_folder(model_path)
        prepare_folder(view_model_path)
        prepare_folder(service_path)

        # Writing code for model
        File.open(model_file_path, "w") { |f| 
            f.write(Generator.create_model_file()) 
        }

        # Writing code for view model
        File.open(viewmodel_file_path, "w") { |f| 
            f.write(Generator.create_view_model_file()) 
        }

        # Writing code for service
        File.open(service_file_path, "w") { |f| 
            f.write(Generator.create_service_file()) 
        }

        project_path = 'DemoCodeGen.xcodeproj'
    
        project = Xcodeproj::Project.open(project_path) 

        main_group = project.main_group["DemoCodeGen"]
        context_group = main_group.new_group(@feature_context)
    
        model_group = context_group.new_group("#{@feature_context}Model")
        viewmodel_group = context_group.new_group("#{@feature_context}ViewModel")
        service_group = context_group.new_group("#{@feature_context}Service")

        model_file = model_group.new_file(model_file_path.split("/").drop(1).join("/"))
        viewmodel_file = viewmodel_group.new_file(viewmodel_file_path.split("/").drop(1).join("/"))
        service_file = service_group.new_file(service_file_path.split("/").drop(1).join("/"))

        main_target = project.targets.first
        main_target.add_file_references([model_file])
        main_target.add_file_references([viewmodel_file])
        main_target.add_file_references([service_file])
        
        project.save

    end

    def prepare_folder(path)
        FileUtils.mkdir_p path
    end

end