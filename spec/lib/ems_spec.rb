#coding: utf-8
require 'spec_helper'
require 'ems_protocol'
require 'ems_protocol/location'
require 'ems_protocol/ems'
require 'ems_protocol/ems_offline'

require File.expand_path('../ems_calculator_shared.rb', __FILE__)

describe "ems online calculator" do
  subject {EmsProtocol::Ems}
  it_should_behave_like "ems calculator"
end
