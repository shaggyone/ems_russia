require 'yaml'
module EmsRussia
  class Cacher
    attr_accessor :value
    attr_accessor :expire_at

    def initialize(attributes = {:value => nil, :expire_at => DateTime.now - 1000.years})
      @value     = attributes[:value]
      @expire_at = attributes[:expire_at] || DateTime.now + 30.days
    end

    def self.init(options = {})
      self.clear_cache
      if options[:file]
        @@cached_values = YAML.load_file(options[:file])
      end
    end

    def self.get(key, datetime = DateTime.now, &block)
      unless cached?(key)
        return nil unless block_given?
        new_expired_at =  datetime + 30.days
        value = yield(((a=cached_values[key]) ? a.clone : new), new_expired_at)
        if value.kind_of? self then
          cached_values[key] = value
        else
          cache_value key, value, new_expired_at
        end
      end
      cached_values[key].value
    end

    def self.clear_cache
      @@cached_values = {}
    end

    def self.save_cache(filename)
      File.open(filename, 'w') do |f|
        YAML::dump(@@cached_values, f)
      end
    end

    def expired?(datetime = DateTime.now)
      self.expire_at <= datetime
    end

    def self.cached?(key, datetime = DateTime.now)
      return false unless cached_values.key?(key)
      ! expired?(key, datetime)
    end
  
    def self.expired?(key, datetime = DateTime.now)
      cached_values[key].expired?
    end

    def self.cache_value(key, value, expire_at = DateTime.now + 15.days)
      cached_values[key] = Cacher.new(:value     => value,
                                      :expire_at => expire_at )
    end

    def self.cached_values
      @@cached_values ||= {}
    end
  end
end
