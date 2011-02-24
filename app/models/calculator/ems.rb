# coding: utf-8
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
    city = object.ship_address.city 
    weight = object.line_items.map(&:variant).map(&:weight).sum

    if city && weight <= Ems.max_weight
      options = { 
        :weight => weight,
        :from => Ems.value_by_name( prefered_from ),
        :to => Ems.value_by_name(object.ship_address.city)
      }
      price = Ems.price( options)
      price.nil? ? nil : BigDecimal.new(price)
    else
      nil
    end
  end

end
