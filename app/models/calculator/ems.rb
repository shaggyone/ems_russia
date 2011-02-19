# coding: utf-8
class Calculator::Ems < Calculator
  preference :from, :string, :default => 'city--sankt-peterburg'
  
  def self.description
    I18n.t("ems_shipping")
  end
  
  def self.register
    super
    ShippingMethod.register_calculator(self)
  end

  def compute(object = nil)
    object.line_items.map(&:variant).map(&:weight).sum
  end

  def get_cities
    json = ActiveSupport::JSON
    http = Net::HTTP
    
    base_url = 'http://emspost.ru/api/rest/?method=ems.get.locations&type=cities&plain=true'
    url = URL.parse base_url
    resp = http.get( url)
    jresp = j.decode resp
    @cities = b['rsp']['locations'] if b['rsp']['stat'] == 'ok'
  end
  def get_city_names
    get_cities unless @cities
    @cities.map{|loc| loc['name']}
  end
end
