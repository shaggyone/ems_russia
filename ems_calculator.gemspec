Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_ems_calculator'
  s.version     = '0.1.0'
  s.summary     = 'EmsCalculator for calculating delivery price'
  #s.description = 'Add (optional) gem description here'
  s.required_ruby_version = '>= 1.8.7'

  s.author            = 'Aleksandr Vladislavovich Kozhukhovskiy'
  s.email             = 'aleksandr@kozhukhovskiy.ru'
  # s.homepage          = 'alkoz.ru'
  # s.rubyforge_project = 'actionmailer'

  s.files        = Dir['CHANGELOG', 'README.md', 'LICENSE', 'lib/**/*', 'app/**/*']
  s.require_path = 'lib'
  s.requirements << 'none'

  s.has_rdoc = true

  s.add_dependency('spree_core', '>= 0.30.1')
end
