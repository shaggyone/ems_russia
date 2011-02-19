require 'spree_core'
require 'ems_calculator_hooks'

module EmsCalculator
  class Engine < Rails::Engine

    config.autoload_paths += %W(#{config.root}/lib)

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
        Rails.env.production? ? require(c) : load(c)
      end
      
      begin
        c_model = Calculator::Ems
        c_model.register if c_model.table_exists?
      rescue Exception => e
        $stderr.puts "Error registering calculator in Calculator::Ems"
      end
    end

    config.to_prepare &method(:activate).to_proc
  end
end
