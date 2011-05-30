Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_ems_calculator'
  s.version     = '0.1.0'
  s.summary     = 'EmsCalculator for calculating delivery price'
  s.description = 'Originally written by Aleksandr Kozhukhovskiy aleksandr@kozhukhovskiy.ru'
  s.required_ruby_version = '>= 1.8.7'

  s.author            = 'Aleksandr Vladislavovich Kozhukhovskiy'
  s.email             = 'victor@zagorski.ru'
  s.homepage          = 'zagorski.ru'
  s.rubyforge_project = ''

  s.files        = Dir['CHANGELOG', 'README.md', 'LICENSE', 'lib/**/*', 'app/**/*']
  s.require_path = 'lib'
  s.requirements << 'none'

  s.has_rdoc = true
end
