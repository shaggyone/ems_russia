require 'ems_russia/cacher'
require 'tempfile'

describe EmsRussia::Cacher do
  it { should respond_to(:expire_at) }
  it { should respond_to(:value) }
end

describe "EmsRussia::Cacher class" do
  subject { EmsRussia::Cacher }
  before { subject.clear_cache }

  it { should respond_to(:get) }
  it { should respond_to(:cache_value) }
  it { should respond_to(:cached_values) }

  it "Should cache values, and clear cache correctly" do
    subject.cached?("sample_key").should be_false
    expect {
      subject.cache_value "sample_key", "sample_value"
    }.to change { subject.cached_values.size }.by(1)
    subject.cached?("sample_key").should be_true
    subject.clear_cache
    subject.cached_values.size.should be == 0
  end

  it "Should expire values" do
    subject.cache_value "sample_key", "sample_value", DateTime.now - 1.day
    subject.expired?("sample_key").should be_true
    subject.cached?("sample_key").should be_false
    subject.get("sample_key").should be_nil
  end

  it "Should cache value, if needed" do
    subject.cache_value "key", "cached_value"
    subject.get("key"){ "recached_value" }.should == "cached_value"
    subject.cache_value "key", "cached_value", DateTime.now - 1.day
    subject.get("key"){ "recached_value" }.should == "recached_value"
  end

  it "Should customize expire_at" do
    dt = DateTime.now + 10.years
    subject.get("key"){|cacher| 
      cacher.value = "new_value"
      cacher.expire_at = dt; 
      cacher
    }.should be  == "new_value"
    subject.cached_values["key"].expire_at.should be == dt
  end

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
