# coding: utf-8
#
# Протокол работы с EMS
require 'uri'
require 'net/http'
class EmsProtocol
  J = ActiveSupport::JSON
  H = Net::HTTP
  METHODS = {
    :locations  => 'ems.get.locations',
    :max_weight => 'ems.get.max.weight',
    :calculate  => 'ems.calculate'
  }
  TYPES  = {
    :cities => 'cities',
    :regions => 'regions',
    :all => 'russia'
  }
  def self.url *args
    options = args.extract_options!
    options[:method]  = METHODS[options[:method]] if options[:method]
    options[:type]    = TYPES[options[:type]] if options[:type]
    options[:plain]   = true
    base = "http://emspost.ru/api/rest/?"
    base << options.to_query
    URI.parse base  
  end
  def self.response *args
    begin
      H.get self.url( args.extract_options!)
    rescue Exception => e
      $stderr.puts "Ошибка соединения с EMS: #{e.inspect}" 
    end
  end
  def self.json *args
    jsn = self.response( args.extract_options!)
    J.decode jsn if jsn
  end
  def self.rsp *args
    jsn = self.json args.extract_options!
    jsn and jsn['rsp'] and jsn['rsp']['stat']=='ok' ? jsn['rsp'] : nil
  end
  
  def self.max_weight
    @@max_weight ||=  if rsp = rsp(:method => :max_weight)
        rsp['max_weight'].to_f
      end
  end
  def self.calculate *args
    options = args.extract_options!
    options[:method] = :calculate
    rsp( options )
  end
  def self.price *args
    result = self.calculate args.extract_options!
    result.nil? ? nil : result['price'] 
  end

  def self.compute_value(from, to, weight)
    if weight <= EmsProtocol.max_weight
      options = { 
        :weight => weight,
        :from   => from,
        :to     => to
      }
      price = EmsProtocol.price( options)
      BigDecimal.new( price.nil? ? "0.0" : price)
    else
      nil
    end
  end
end
