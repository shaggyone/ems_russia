class EmsProtocol::Location 
  def self.all
    unless class_variable_defined?('@@locations') # ugly, but don't now how more accurate verify
      js = js_request
      if js['rsp']['stat'] == 'ok'
        cache_and_index js['rsp']['locations']
      end
    else
      @@locations
    end
  end

  def self.all_regions
    self.all_by_type 'regions'
  end

  def self.all_cities
    self.all_by_type 'cities'
  end

  def self.all_by_name name
    self.all # grant that locations cached and indexed
    @@locations_by_name[name]
  end
  def self.all_by_value value
    self.all
    @@locations_by_value[value]
  end
  def self.all_by_type type
    self.all
    @@locations_by_type[type]
  end
  def self.reset_cache
    [ :@@locations, 
      :@@locations_by_name, 
      :@@locations_by_value, 
      :@@locations_by_type ].each{ |v| remove_class_variable v}
    true
  end
  def self.value_by_name name
    location = self.all_by_name(name)
    location ? location['value'] : nil
  end
  def self.name_by_value value
    location = self.all_by_value(value)
    location ? location['name'] : nil
  end
  def self.by_type type
    location = self.all_by_type(type)
    location ? location : nil
  end
  private
  #Template_method:
  def self.js_request
    EmsProtocol.json(:method => :locations, :type => :all)
  end
  def self.cache_and_index locations
    @@locations = locations
    @@locations_by_name = {}
    @@locations_by_value = {}
    @@locations_by_type  = {}
    @@locations.each do |location|
      @@locations_by_name[location['name']] = location
      @@locations_by_value[location['value']] = location
      @@locations_by_type[location['type']] = [] if @@locations_by_type[location['type']].nil?
      @@locations_by_type[location['type']] << location
    end
  end
end
