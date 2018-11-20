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

        # Get CWD:
        cwd_result = run_powershell_inline_json("(Get-Item -Path '.\\').FullName")
        cwd = cwd_result.stdout
        puts "Hey, here's the cwd: #{cwd}"

        # Get IP Address and switch
        network_result = run_powershell_inline_json("Get-VM | Where-Object {$_.State -eq 'Running'} | Select -ExpandProperty NetworkAdapters | Select VMName, IPAddresses, SwitchName | ConvertTo-Json")
        network = JSON.parse(network_result.stdout)
        puts "Hey, here's the network JSON: #{network.inspect}"

        # Get Configuration Dir
        config_result = run_powershell_inline_json("Get-VM | Where-Object {$_.State -eq 'Running'} | Select VMName, ConfigurationLocation | ConvertTo-Json")
        config = JSON.parse(config_result.stdout)
        puts "Hey, here's the config JSON: #{config.inspect}"
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

