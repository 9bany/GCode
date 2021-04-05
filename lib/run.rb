
# require 'xcodeproj'
require 'yaml'
require_relative 'blancer/blancer.rb'
def main
    
    # project_path = 'DemoCodeGen.xcodeproj'
    
    # project = Xcodeproj::Project.open(project_path)
    
    # group = project.main_group['DemoCodeGen']
    # groupDemo = group.new_group('Demo2')

    # file = groupDemo.new_file('Hello.swift')
    
    # main_target = project.targets.first
    # main_target.add_file_references([file])
    
    # project.save
    thing = YAML.load_file('./config.yml')
    puts thing

    blacing = CreateBlancing.new("MVVM")
    # blacing.create()
end

main()