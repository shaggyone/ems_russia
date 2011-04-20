begin
  Address.class_eval do
    validates_with EmsAddressValidator    
  end
rescue Exception => e
end
