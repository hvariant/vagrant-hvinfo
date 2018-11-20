module VagrantPlugins
  module CommandHVInfo
    module Errors
      class VagrantHVInfoError < Vagrant::Errors::VagrantError
      end

      # https://stackoverflow.com/questions/26687264/how-to-create-a-custom-vagranterror-class-that-does-not-use-i18n
      class PowershellNotAvailable < VagrantHVInfoError
        def initialize
          error_message = "Powershell is not available on your system"
          StandardError.instance_method(:initialize).bind(self).call(error_message)
        end
      end

      class PowershellCommandFailed < VagrantHVInfoError
        def initialize(cmd, rc, stdout, stderr)
          error_message =  "Powershell command '#{cmd}' failed, rc=#{rc}, stdout='#{stdout}', stderr='#{stderr}'"
          StandardError.instance_method(:initialize).bind(self).call(error_message)
        end
      end
    end
  end
end

