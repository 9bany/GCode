require 'fileutils'
require_relative './../constants/path.rb'

# Creator ...
class Creator
    @@architect_context = ""
    @@feature_context = ""
    
    def initialize(architect_context, feature_context)
        @architect_context = architect_context
        @feature_context = feature_context
    end

    def excute
        
        FileUtils.mkdir_p "#{PATH.model(@feature_context)}"
        FileUtils.mkdir_p "#{PATH.view_model(@feature_context)}"
        FileUtils.mkdir_p "#{PATH.service(@feature_context)}"

        File.open("#{PATH.model(@feature_context)}/#{@feature_context}#{PATH::EXTENSION}", "w") { |f| 
            f.write("write your stuff here, ok") 
        }
    end
end