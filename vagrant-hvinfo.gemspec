Gem::Specification.new do |spec|
  spec.name          = 'vagrant-hvinfo'
  spec.version       = '0.1.1'
  spec.authors       = ['Zhansong Li']
  spec.email         = ['lizhansong@hvariant.com']
  spec.summary       = 'Vagrant plugin for displaying information about Hyper-V VMs'
  spec.homepage      = 'https://github.com/hvariant/vagrant-hvinfo'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.require_paths = ['lib']

  spec.metadata = {
    "homepage_uri" => 'https://github.com/hvariant/vagrant-hvinfo',
    "source_code_uri" => 'https://github.com/hvariant/vagrant-hvinfo',
  }

  spec.bindir = 'bin'
  spec.platform = Gem::Platform::CURRENT
  spec.required_ruby_version = '>= 2.3.3'

  spec.requirements << 'vagrant'
  spec.requirements << 'Powershell v3 or newer'
  spec.requirements << 'Hyper-V'
end

