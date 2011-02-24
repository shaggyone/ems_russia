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
    city = object.address.city 
    weight = object.line_items.map(&:variant).map(&:weight).sum

    if city && weight <= EmsProtocol.max_weight
      options = { 
        :weight => weight,
        :from => EmsProtocol::Location.value_by_name( preferred_from ),
        :to => EmsProtocol::Location.value_by_name(object.address.city)
      }
      price = EmsProtocol.price( options)
      price.nil? ? nil : BigDecimal.new(price)
    else
      nil
    end
  end

end
