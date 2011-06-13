# coding: utf-8
require 'yaml'
class EmsOffline #< Ems
  def self.load_yaml(filename)
    cacher.init :file => filename
  end

  def self.save_yaml(filename)
    cacher.save_cache filename
  end
# Does not work. Why ?
# @@PROXY_METHODS = [:all, :all_cities, :all_regions, :max_weight]
# @@PROXY_METHODS.each do|method_name|
#   self.send :define_method, method_name do
#     cacher.get(method_name) { Ems.send method_name }
#   end
# end

  def self.all
    cacher.get(:all) {
      @@all_by_name = nil
      @@all_by_internal_name = nil
      Ems.all
    }
  end

  def self.all_by_name
    @@all_by_name ||= Hash[all.map do |v|
      [v[:name], v]
    end]
  end

  def self.all_by_internal
    @@internal_by_name ||= Hash[all.map do |v|
      [v[:internal].mb_chars.downcase, v]
      [v[:internal], v]
    end]
  end

  def self.internal_by_name(name)
    (a=all_by_name[name]) ? a[:internal] : nil
  end

  def self.internal_by_path(path)
    path.gsub("Аобл", "АО").split(",").map(&:strip).map {|x| internal_by_name(x)}.last
  end

  def self.name_by_internal(internal)
    all_by_internal[internal][:name]
  end

  def self.all_cities
    cacher.get(:all_cities){Ems.all_cities}
  end

  def self.all_regions
    cacher.get(:all_regions){Ems.all_regions}
  end

  def self.all_weights
    @@all_weights ||= [1..max_weight*2].map do |dbl_weight|
      weight = dbl_weight / 2.0
    end
  end

  def self.max_weight
    cacher.get(:max_weight){Ems.max_weight}
  end

  def self.calc_price(from, to, weight)
    cacher.get(price_key(from, to, weight)) { 
      sleep 2
      Ems.calc_price(from, to, weight)
    }
  end

  def self.cache_data(options)
    self.cache_simple_data
    self.cache_prices options
#   self.cacher.cached_values.keys
  end

  def self.cache_simple_data
    [:all, :all_cities, :all_regions, :max_weight].each do|method_name|
#     cacher.cached_values.delete method_name
      self.send method_name
      sleep 2
    end
  end

  def self.cache_prices(options = {})
#   cacher.cached_values.delete_if { |key, value| key.to_s.starts_with? "price:" }
    weights = options[:weights] || all_weights.first(3)
    from = options[:from] || "city--sankt-peterburg"
    to   = options[:to] || "city--krasnojarsk"
    weights = [weights] unless weights.kind_of? Array
    from = [from] unless from.kind_of? Array
    to   = [to]   unless to.kind_of?   Array
    weights.each do |w|
      from.each do |f|
        to.each do |t|
          puts "Caching #{f}-{#t}-#{w}"
          calc_price f, t, w
        end
      end
    end
  end

private
  def self.weight_region(weight)
    return [0.0, 0.5] if weight <= 0
    a=((weight*2).floor/2.0)
    [(a==weight ? a-0.5 : a).to_f, ((weight*2).ceil/2.0).to_f]
  end

  def self.price_key(from, to, weight)
    from_weight, to_weight = weight_region(weight)
    "price:#{from}|#{to}|#{from_weight}|#{to_weight}"
  end

  def self.get_price(from, to, weight)
    prices = self.get_route_prices(from, to)
    prices.find {|prices_data| prices_data[:from_weight] < weight && weight <= prices_data[:to_weight]}
  end

  def self.cacher
    ::EmsRussia::Cacher
  end
end
