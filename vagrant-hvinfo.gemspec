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
end

