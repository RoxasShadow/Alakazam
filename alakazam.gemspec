Kernel.load 'lib/alakazam/version.rb'

Gem::Specification.new { |s|
  s.name          = 'alakazam'
  s.version       = Alakazam::VERSION
  s.author        = 'Giovanni Capuano'
  s.email         = 'webmaster@giovannicapuano.net'
  s.homepage      = 'https://github.com/RoxasShadow'
  s.summary       = 'An observer with everything you need'
  s.description   = 'Alakazam provides methods to observe all your things.'
  s.licenses      = 'WTFPL'

  s.require_paths = ['lib']
  s.files         = Dir.glob('lib/**/*.rb')
  s.test_files    = Dir.glob('tests/**/*_spec.rb')

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
}