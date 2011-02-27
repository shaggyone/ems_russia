# coding: utf-8
#
# Калькулятор для EMS
class Calculator::Ems < Calculator
  preference :from, :string, :default => 'Санкт-Петербург'
  
  def self.description
    I18n.t("ems_shipping")
  end
  
  def self.register
    super
    ShippingMethod.register_calculator(self)
  end

  def compute(object = nil)
    Rails.logger.info{ "object : " + object.inspect }
    address = 
      if object.is_a?(Order)
        object.ship_address
      elsif object.is_a?(Shipment)
        object.address
      else
        nil
      end
    city = address.city
    weight = object.line_items.map(&:variant).map(&:weight).sum

    if city && weight <= EmsProtocol.max_weight
      options = { 
        :weight => weight,
        :from => EmsProtocol::Location.value_by_name( preferred_from ),
        :to => EmsProtocol::Location.value_by_name( city )
      }
      price = EmsProtocol.price( options)
      BigDecimal.new( price.nil? ? 0 : price)
    else
      nil
    end
  end

end
