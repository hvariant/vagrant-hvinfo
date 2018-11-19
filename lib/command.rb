require 'optparse'

module VagrantPlugins
  module CommandHVInfo
    class Command < Vagrant.plugin("2", :command)
      def self.synopsis
        "outputs information about Hyper-V VMs"
      end

      def execute
        opts = OptionParser.new do |o|
          o.banner = "Usage: vagrant address [name]"
        end
        argv = parse_options(opts)
        return if !argv

        puts "Hello, #{argv[1]} !"
      end
    end
  end
end

