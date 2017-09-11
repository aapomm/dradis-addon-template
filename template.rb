plugin_name = name.gsub('-', '_')
camelized_name = plugin_name.camelize

remove_file 'test/'
remove_file 'bin'
remove_file 'lib'

empty_directory 'templates/'

##### LIB FILES #####
empty_directory "lib/#{name}"

# Main gem file
create_file "lib/dradis-#{plugin_name}.rb" do
<<-EOS
require 'dradis/plugins'\n
require 'dradis/plugins/#{plugin_name}'
EOS
end

# Main gem plugin class
create_file "lib/dradis/plugins/#{plugin_name}.rb" do
<<-EOS
module Dradis
  module Plugins
    module #{camelized_name}
    end
  end
end

require 'dradis/plugins/#{plugin_name}/engine'
require 'dradis/plugins/#{plugin_name}/field_processor'
require 'dradis/plugins/#{plugin_name}/importer'
require 'dradis/plugins/#{plugin_name}/version'
EOS
end

# engine.rb
create_file "lib/dradis/plugins/#{plugin_name}/engine.rb" do
<<-EOS
module Dradis
  module Plugins
    module #{camelized_name}
      class Engine < ::Rails::Engine
        isolate_namespace Dradis::Plugins::#{camelized_name}

        include ::Dradis::Plugins::Base
        description 'Addon for importing XML from #{plugin_name}.'
        provides :upload
      end
    end
  end
end
EOS
end

# field_processor.rb
create_file "lib/dradis/plugins/#{plugin_name}/field_processor.rb" do
<<-EOS
module Dradis
  module Plugins
    module #{camelized_name}
      class FieldProcessor < Dradis::Plugins::Upload::FieldProcessor
        def post_initialize(args={})
          # This method is an optional callback for when you want to instantiate
          # your data models depending on the XML data name.
        end

        def value
          # This method is called by the Template Service to get the values of
          # the fields defined in the plugin's template.
        end
      end
    end
  end
end
EOS
end

# importer.rb
create_file "lib/dradis/plugins/#{plugin_name}/importer.rb" do
<<-EOS
module Dradis::Plugins::#{camelized_name}
  class Importer < Dradis::Plugins::Upload::Importer
    def import(params={})
      # This is where the actual code for parsing the XML file comes in.
      # Ideally, you would put your code here that would read the XML and
      # create the comparable Dradis elements.
    end
  end
end
EOS
end

# version.rb
create_file "lib/dradis/plugins/#{plugin_name}/version.rb" do
<<-EOS
require_relative 'gem_version'

module Dradis
  module Plugins
    module #{camelized_name}
      def self.version
        gem_version
      end
    end
  end
end
EOS
end

# gem_version.rb
create_file "lib/dradis/plugins/#{plugin_name}/gem_version.rb" do
<<-EOS
module Dradis
  module Plugins
    module #{camelized_name}
      def self.gem_version
        Gem::Version.new VERSION::STRING
      end

      module VERSION
        MAJOR = 1
        MINOR = 0
        TINY = 0
        PRE = nil

        STRING = [MAJOR, MINOR, TINY, PRE].compact.join(".")
      end
    end
  end
end
EOS
end

# thorfile.rb
create_file "lib/tasks/thorfile.rb" do
<<-EOS
class #{camelized_name}Tasks < Thor
nclude Rails.application.config.dradis.thor_helper_module

  namespace "dradis:plugins:#{plugin_name}"

  desc "upload FILE", "upload #{camelized_name} XML file"
  def upload(file_path)
    require 'config/environment'

    unless File.exists?(file_path)
      $stderr.puts "** the file [#{file_path}] does not exist"
      exit(-1)
    end

    detect_and_set_project_scope
    importer = Dradis::Plugins::#{camelized_name}::Importer.new(task_options)
    importer.import(file: file_path)
  end
end
EOS
end


##### SPEC FILES #####
create_file "spec/spec_helper.rb" do
<<-EOS
require 'rubygems'
require 'bundler/setup'
require 'nokogiri'

require 'combustion'

Combustion.initialize!

RSpec.configure do |config|
end
EOS
end
