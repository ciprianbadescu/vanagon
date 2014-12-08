require 'vanagon/component/source'

class Vanagon
  class Component
    attr_accessor :name, :version, :source, :md5sum, :url, :configure, :build, :install, :environment, :extract_with, :dirname, :build_requires, :version, :settings, :platform, :files, :patches, :requires, :service

    def self.load_component(name, configdir, settings, platform)
      compfile = File.join(configdir, "#{name}.rb")
      code = File.read(compfile)
      dsl = Vanagon::Component::DSL.new(name, settings, platform)
      dsl.instance_eval(code)
      dsl._component
    rescue => e
      puts "Error loading project '#{name}' using '#{compfile}':"
      puts e
      puts e.backtrace.join("\n")
      raise e
    end

    def initialize(name, settings, platform)
      @name = name
      @settings = settings
      @platform = platform
      @build_requires = []
      @requires = []
      @configure = []
      @install = []
      @build = []
      @patches = []
      @files = []
    end

    def get_source(workdir)
      @source = Vanagon::Component::Source.source(@url, @md5sum, workdir)
      @source.fetch
      @source.verify
      @extract_with = @source.extract
      @dirname = @source.dirname
    end
  end
end
