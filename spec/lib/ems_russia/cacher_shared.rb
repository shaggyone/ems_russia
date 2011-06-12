shared_examples_for "ems_russia/cacher" do
  before { subject.clear_cache }

  it { should respond_to(:get) }
  it { should respond_to(:cache_value) }

  it "Should cache values, and clear cache correctly" do
    subject.cached?("sample_key").should be_false
    subject.cache_value "sample_key", "sample_value"
    subject.cached?("sample_key").should be_true
    subject.clear_cache
    subject.cached?("sample_key").should be_false
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
    subject.get_cached("key").expire_at.should be == dt
  end
end
