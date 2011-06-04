#coding: utf-8
require 'spec_helper'
require 'ems_protocol'
require 'ems_protocol/location'
require 'ems'
require 'ems_offline'
require 'ems_russia/cacher'

require File.expand_path('../ems_calculator_shared', __FILE__)

require 'pp'

describe "ems offline calculator" do
  subject {EmsOffline}
  
  it "Print all names" do
#    pp subject.all_by_name
  end

  it_should_behave_like "ems calculator"

  it { should respond_to(:load_yaml) }

  it "Should return correct region" do
    subject.weight_region(-1).should  be == [0.0, 0.5]
    subject.weight_region(0).should   be == [0.0, 0.5]
    subject.weight_region(0.1).should be == [0.0, 0.5]
    subject.weight_region(0.5).should be == [0.0, 0.5]
    subject.weight_region(0.6).should be == [0.5, 1.0]
    subject.weight_region(1.0).should be == [0.5, 1.0]
    subject.weight_region(1.1).should be == [1.0, 1.5]
    subject.weight_region(1.5).should be == [1.0, 1.5]
    subject.weight_region(1.6).should be == [1.5, 2.0]
  end

  it "should compute correct price cache key" do
    subject.price_key("city--sankt-peterburg", "city--krasnojarsk", 1.1).should be == "price:city--sankt-peterburg|city--krasnojarsk|1.0|1.5"
  end

  it "should have all_by_name" do
     subject.all_by_name["Красноярск"][:internal].should be == "city--krasnojarsk"
  end

  it "should be able to update cache" do
    subject.all_by_name
    subject.cache_simple_data.should be == [:all, :all_cities, :all_regions, :max_weight]
    [:all, :all_cities, :all_regions, :max_weight].each do |key|
      subject.cacher.cached?(key).should be_true
    end
  end
  it "should cache price" do
    from, to = "city--sankt-peterburg", "city--krasnojarsk"
    subject.calc_price(from, to, 1.1)
    subject.cacher.cached?("price:city--sankt-peterburg|city--krasnojarsk|1.0|1.5").should be_true
  end

  it "should be able to cache multiple prices" do
    from, to = "city--sankt-peterburg", "city--krasnojarsk"
    subject.cache_prices(:from => from, :to => to, :weights => [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 1.0])
    subject.cacher.cached_values.find_all{|k, v| k.to_s.start_with? "price:"}.should have(2).items
  end

  it "should be able to save cached prices" do
    tempfile = Tempfile.new('sample.yml')
    begin
    from, to = "city--sankt-peterburg", "city--krasnojarsk"
      subject.cache_prices(:from => from, :to => to, :weights => [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 1.0])
      subject.save_yaml tempfile.path
    ensure
      tempfile.unlink
    end
  end
end
