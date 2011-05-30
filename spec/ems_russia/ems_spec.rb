#coding: utf-8
require File.dirname(__FILE__) + '/../spec_helper'
require 'ems_protocol'
require 'ems_protocol/location'
require 'ems'

describe "EMS Calculator Interface" do
  it "should list with locations" do
    all         = Ems.all
    all_cities  = Ems.all_cities
    all_regions = Ems.all_regions
    [all, all_cities, all_regions].each do|x|
      x.should be_kind_of(Array)
      x.each do |y|
        y[:internal].should_not be_nil
        y[:name].should_not be_nil
        y[:type].should_not be_nil
      end
    end
    all_cities.each do |x|
      x[:type].should be == :city
    end    
    all_regions.each do |x|
      x[:type].should be == :region
    end
  end

  it "should give you internal and deisplayed name" do
    Ems.internal_by_name("Красноярск").should be == "city--krasnojarsk"
    Ems.internal_by_path("Железногорск, Красноярский край").should be == "region--krasnojarskij-kraj"
    Ems.internal_by_path("Раздолинск, Матыгинский район, Красноярский край").should be == "region--krasnojarskij-kraj"
    Ems.name_by_internal("city--krasnojarsk").should == "Красноярск"
  end

  it "should give max weight" do
    max_weight = Ems.max_weight
    max_weight.should be_kind_of Numeric
    max_weight.should be > 0
  end

  it "should calculate price" do
    price = Ems.calc_price("city--sankt-peterburg", "city--krasnojarsk", 11.1)
    price.should be_kind_of Numeric
    price.should be > 0
  end
end
