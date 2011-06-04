#coding: utf-8
require 'spec_helper'
require 'ems_protocol'
require 'ems_protocol/location'
require 'ems'
require 'ems_offline'

shared_examples_for "ems calculator" do
  context "locations" do
    let(:all_locations) { subject.all }
    let(:all_cities)    { subject.all_cities }
    let(:all_regions)   { subject.all_regions }
    
    it "should cover all regions" do
      all_locations.size.should be == (all_cities.size + all_regions.size)
    end

    it "should list with locations" do
      [all_locations, all_cities, all_regions].each do|x|
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
  end
  
  it "should give you internal and displayed name" do
    subject.internal_by_name("Красноярск").should be == "city--krasnojarsk"
    subject.internal_by_path("Железногорск, Красноярский край").should be == "region--krasnojarskij-kraj"
    subject.internal_by_path("Раздолинск, Матыгинский район, Красноярский край").should be == "region--krasnojarskij-kraj"
    subject.name_by_internal("city--krasnojarsk").should == "Красноярск"
  end

  it "should give max weight" do
    max_weight = subject.max_weight
    max_weight.should be_kind_of Numeric
    max_weight.should be > 0
  end

  it "should calculate price" do
    price = subject.calc_price("city--sankt-peterburg", "city--krasnojarsk", 11.1)
    price.should be_kind_of Numeric
    price.should be > 0
  end
end
