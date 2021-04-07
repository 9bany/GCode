
require 'singleton'

class Configuration
    include Singleton

    @@project_path

    def set_project_path(path_name)
        @project_path = path_name
    end

    def get_project_path()
        return @project_path
    end
end