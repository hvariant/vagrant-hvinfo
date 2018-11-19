require "vagrant"

module VagrantPlugins
  module CommandHVInfo
    class Plugin < Vagrant.plugin("2")
      name "hvinfo"
      description <<-DESC
      The `hvinfo` command outputs information about Hyper-V VMs.
      DESC

      command("hvinfo", primary: false) do
        require_relative "command"
        Command
      end
    end
  end
end

