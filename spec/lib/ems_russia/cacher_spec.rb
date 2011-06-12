require 'ems_russia/cacher'
require 'tempfile'

require File.expand_path('../cacher_shared.rb', __FILE__)

describe EmsRussia::Cacher do
  it { should respond_to(:expire_at) }
  it { should respond_to(:value) }
end

describe "EmsRussia::Cacher class" do
  subject { EmsRussia::Cacher }
  before { subject.clear_cache }

  it_should_behave_like "ems_russia/cacher"

  it { should respond_to(:get) }
  it { should respond_to(:cache_value) }
  it { should respond_to(:cached_values) }

  it { should respond_to(:init) }

  it "Should be empty, after blank init" do
    subject.init
    subject.cached_values.size.should be == 0
  end

  it "Should have correct entries after init on file" do
    subject.init :file => File.expand_path('../examples/sample_data.yml', __FILE__)
    subject.cached_values.size.should be > 0
    subject.expired?("key_1").should_not be_true
    subject.expired?("key_2").should be_true
    subject.get("key_1"){"recached_data_1"}.should be == "data_1"
  end

  it { should respond_to(:save_cache) }

  it "Should save the file_correctly" do
    tempfile = Tempfile.new('sample.yml')
    begin
      subject.cache_value "key", "cached_value"
      subject.save_cache tempfile.path
      subject.clear_cache
      subject.init :file => tempfile.path
      subject.cached?("key").should be_true
      subject.get("key").should be == "cached_value"
    ensure
      tempfile.unlink
    end
  end
end
