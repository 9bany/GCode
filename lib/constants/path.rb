
require_relative './../config/config.rb'

# PATH ...
class PATH
    
    def self.model(context)
        return "#{Configuration.instance.get_project_path()}/#{context}/Model"
    end

    def self.view_model(context)
        return "#{Configuration.instance.get_project_path()}/#{context}/ViewModel"
    end

    def self.service(context)
        return "#{Configuration.instance.get_project_path()}/#{context}/Services"
    end

    def self.model_with_file(context)
        return "#{Configuration.instance.get_project_path()}/#{context}/Model/#{context}Entity"
    end

    def self.view_model_with_file(context)
        return "#{Configuration.instance.get_project_path()}/#{context}/ViewModel/#{context}ViewModel"
    end

    def self.service_with_file(context)
        return "#{Configuration.instance.get_project_path()}/#{context}/Services/#{context}Repository"
    end

    SWIFT_EXTENSION = ".swift"
    
end