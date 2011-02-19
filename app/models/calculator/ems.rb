class Calculator::Ems < Calculator
  preference :amount, :decimal, :default => 0
  
  def self.description
    I18n.t("ems_shipping")
  end
  
  def self.register
    super
    ShippingMethod.register_calculator(self)
  end

  def compute(object = nil)
    self.preffered_amount
  end
end
