require 'ems_russia/cacher_module'

class ActiveRecordCacher < ActiveRecord::Base
  acts_as_cacher
end
