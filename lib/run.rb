
require 'xcodeproj'
require 'yaml'
require_relative 'components/blancer/blancer.rb'
require_relative 'config/config.rb'

def main
    
    # thing = YAML.load_file('./config.yml')
    # thing = YAML::load_file(File.join(__dir__, 'config/config.yml'))

    # puts thing["data"]["name_1"]
    Configuration.instance.set_project_path("DemoCodeGen")
    blacing = CreateBlancing.new("MVVM")
    blacing.create()
end

main()