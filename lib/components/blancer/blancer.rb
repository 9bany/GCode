
require_relative './../../constants/context.rb'
require_relative './../creators/creator.rb'
require_relative './../../config/config.rb'
# CreateBlancing ...

class CreateBlancing
    @@context = ""
    def initialize(context)
        @context = context
    end

    def create
        case @context
            when CONTEXT::MVVM
                puts "OK: We will use this context: #{@context}."
                creator = Creator.new(@context, "User")
                creator.excute()
            else 
                puts "ERROR: We don't support your context: #{@context}."
        end
    end
end