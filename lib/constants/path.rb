# PATH ...
class PATH
    
    def self.model(context)
        return "./#{context}/Model"
    end

    def self.view_model(context)
        return "./#{context}/ViewModel"
    end

    def self.service(context)
        return "./#{context}/Services"
    end

    EXTENSION = ".swift"
    
end