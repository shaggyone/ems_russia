Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'ems_russia'
  s.version     = '0.0.0.a1'
  s.summary     = 'EmsCalculator for calculating delivery price'
  s.description = 'Original protocol realization was extracted from spree_ems_calculator by Aleksandr Kozhukhovskiy aleksandr@kozhukhovskiy.ru'
  s.required_ruby_version = '>= 1.8.7'

  s.author            = 'Victor Zagorski aka shaggyone'
  s.email             = 'victor@zagorski.ru'
  s.homepage          = 'zagorski.ru'
  s.rubyforge_project = ''

  s.files        = Dir['CHANGELOG', 'README.md', 'LICENSE', 'lib/**/*', 'app/**/*']
  s.require_path = 'lib'
  s.requirements << 'none'

  s.has_rdoc = true
end
