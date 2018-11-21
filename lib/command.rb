require 'optparse'
require 'vagrant/util/powershell'
require 'json'
require_relative 'errors'

module VagrantPlugins
  module CommandHVInfo
    class Command < Vagrant.plugin("2", :command)
      def self.synopsis
        "outputs information about Hyper-V VMs"
      end

      def execute
        if not Vagrant::Util::PowerShell.available?
          raise PowershellNotAvailable
        end

        opts = OptionParser.new do |o|
          o.banner = "Usage: vagrant hvinfo [output-file]"
        end
        argv = parse_options(opts)
        return if !argv

        # Get CWD:
        cwd_result = run_powershell_inline_json("(Get-Item -Path '.\\').FullName")
        cwd = cwd_result.stdout

        # Get IP Address and switch
        network_result = run_powershell_inline_json("Get-VM | Where-Object {$_.State -eq 'Running'} | Select -ExpandProperty NetworkAdapters | Select VMName, IPAddresses, SwitchName | ConvertTo-Json")
        network = JSON.parse(network_result.stdout)

        # Get Configuration Dir
        config_result = run_powershell_inline_json("Get-VM | Where-Object {$_.State -eq 'Running'} | Select VMName, ConfigurationLocation | ConvertTo-Json")
        config = JSON.parse(config_result.stdout)

        # Filter out VMs that are not managed by vagrant in this folder
        vagrant_vms = {}
        for vm in config
          vm_name = vm["VMName"]
          vm_config_path = vm["ConfigurationLocation"]
          if vm_config_path.strip.upcase.start_with?(cwd.strip.upcase)
            vagrant_vms[vm_name] = vm
          end
        end

        # add network properties to resulting hash
        for vm in network
          vm_name = vm["VMName"]
          if vagrant_vms.has_key?(vm_name)
            for key in vm.keys
                vagrant_vms[vm_name] = vagrant_vms[vm_name].merge(vm)
            end
          end
        end

        json_pretty = JSON.pretty_generate(vagrant_vms.values)
        if argv.length == 0
          puts json_pretty
          return 0
        else
          begin
            file = File.open(argv[0], "w")
            file.write(json_pretty)
            return 0
          rescue IOError => e
            puts "Failed to write results to file #{argv[0]}, error: #{e.inspect}"
          rescue Errno::ENOENT => e
            puts "Failed to write results to file #{argv[0]}, error: #{e.inspect}"
          ensure
            file.close unless file.nil?
          end

          return -1 # something went wrong, maybe
        end
      end

      private

      def run_powershell_inline_json(cmd)
        result = Vagrant::Util::PowerShell.execute_inline(cmd)
        
        if result.exit_code != 0
          raise Errors::PowershellCommandFailed.new cmd, result.exit_code, result.stdout, result.stderr
        end

        return result
      end
    end
  end
end

