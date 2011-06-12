require 'spec_helper'
require 'pp'
require File.expand_path("../../../test_app/app/models/active_record_cacher", __FILE__)
require File.expand_path('../cacher_shared.rb', __FILE__)

describe ActiveRecordCacher do
  subject { ActiveRecordCacher }

# it { pp subject.name }
# it { pp subject.public_methods.sort }
# pp ActiveRecordCacher.public_methods.sort

  it {should respond_to :get_cached, :set_cached }

  it_should_behave_like "ems_russia/cacher"
end
