class EmsAddressValidator < ActiveModel::Validator
  def validate(address)
    puts "EmsAddressValidator.validate"
    return unless address.country.iso == "RU"
    return if ::EmsProtocol::Location.value_by_name(address.city)
    if address.state_name.blank? 
      address.errors[:state_name] << I18n.t(:"address.errors.state_name_needed")
      return
    end
    return if ::EmsProtocol::Location.value_by_name(address.state_name)
    address.errors[:state_name] << I18n.t(:"address.errors.correct_state_name_needed")
  end
end
