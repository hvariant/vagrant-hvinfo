require 'optparse'
require 'vagrant/util/powershell'

module VagrantPlugins
  module CommandHVInfo
    class Command < Vagrant.plugin("2", :command)
      def self.synopsis
        "outputs information about Hyper-V VMs"
      end

      def execute
        opts = OptionParser.new do |o|
          o.banner = "Usage: vagrant hvinfo [name]"
        end
        argv = parse_options(opts)
        return if !argv

        output = Vagrant::Util::PowerShell.execute_inline('ls C:/Ruby23-x64/')

        puts "powershell output:"
        puts "exit code: #{output.exit_code}"
        puts "stdout: #{output.stdout}"
        puts "stderr: #{output.stderr}"
      end
    end
  end
end

