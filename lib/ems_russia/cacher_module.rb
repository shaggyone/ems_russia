require 'yaml'
module EmsRussia
  module CacherInstanceModule
    def expired?(datetime = DateTime.now)
      self.expire_at <= datetime
    end
  end

  module CacherClassModule
    def get(key, datetime = DateTime.now, new_value=nil, &block)
      unless cached?(key)
        return nil unless block_given?
        new_expired_at =  datetime + 30.days
        if block_given?
          value = yield(((a=get_cached(key)) ? a.clone : new), new_expired_at)
        else
          value = new_value
        end
        if value.kind_of? self then
          cache_value key, value.value, value.expire_at
        else
          cache_value key, value, new_expired_at
        end
      end
      get_cached(key).value
    end

    def cached?(key, datetime = DateTime.now)
      return false unless tmp = self.get_cached(key)
      ! expired?(key, datetime)
    end
  
    def expired?(key, datetime = DateTime.now)
      tmp = self.get_cached(key)
      tmp.nil? || tmp.expired?
    end

    def cache_value(key, value, expire_at = DateTime.now + 15.days)
      self.set_cached key, value, expire_at
    end
  end

  module CacherActiveRecordModule
    def get_cached(key)
      contained_values[key] = self.find_by_key(key)
      contained_values[key]
    end

    def set_cached(key, value, expire_at)
      a = (get_cached(key) || contained_values[key] = self.new(:key => key))
      a.value     = value
      a.expire_at = expire_at
      a.save
      a
    end

    def contained_values
      @@contained_values ||= {}
    end

    def clear_cache
      self.delete_all
    end
  end
end

module ActiveRecord
  Base.class_eval do
    def self.acts_as_cacher
      include ::EmsRussia::CacherInstanceModule
      extend  ::EmsRussia::CacherClassModule
      extend  ::EmsRussia::CacherActiveRecordModule
      serialize :value
    end
  end
end

