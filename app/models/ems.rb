# coding: utf-8
class Ems
  require 'uri'
  J = ActiveSupport::JSON
  H = Net::HTTP
  METHODS = {
    :locations => 'ems.get.locations',
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
  #TODO Вынести в отдельный класс
  #TODO Еще раз - задумайся о создании отдельного подкласса для хранения локейшнов
  
  def self.max_weight
    #TODO see before, must verify response status
    @@max_weight ||=  if rsp = rsp(:method => :max_weight)
        rsp['max_weight']
      end
  end
  def self.calculate *args
    options = args.extract_options!
    options[:method] = :calculate
    rsp( options )#['price']
  end
  def self.price *args
    result = self.calculate args.extract_options!
    result.nil? ? nil : result['price'] 
  end
end
