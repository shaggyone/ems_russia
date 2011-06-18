class EmsProtocol::Ems
  def self.all
    EmsProtocol::Location.all.map {|x| 
      {
        :internal => x["value"],
        :name     => x["name"],
        :type     => (x["type"]=="cities") ? :city : :region
      }
    }
  end

  def self.all_cities
    EmsProtocol::Location.all_cities.map {|x| 
      {
        :internal => x["value"],
        :name     => x["name"],
        :type     => (x["type"]=="cities") ? :city : :region
      }
    }
  end

  def self.all_regions
    EmsProtocol::Location.all_regions.map {|x| 
      {
        :internal => x["value"],
        :name     => x["name"],
        :type     => (x["type"]=="cities") ? :city : :region
      }
    }
  end

  def self.internal_by_name(name)
    EmsProtocol::Location.value_by_name(name)
  end

  def self.internal_by_path(name)
    EmsProtocol::Location.value_by_path(name)
  end

  def self.name_by_internal(internal)
    EmsProtocol::Location.name_by_value(internal)
  end

  def self.max_weight
    EmsProtocol.max_weight
  end

  def self.calc_price(from, to, weight)
    EmsProtocol.compute_value(from, to, weight)
  end
end
