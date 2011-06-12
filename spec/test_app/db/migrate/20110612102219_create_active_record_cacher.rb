class CreateActiveRecordCacher < ActiveRecord::Migration
  def self.up
    create_table :active_record_cachers do |t|
      t.string :key
      t.text   :value
      t.datetime :expire_at

      t.timestamps
    end
  end

  def self.down
    drop_table :active_record_cachers
  end
end
