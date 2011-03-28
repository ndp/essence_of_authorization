class CreateAuthorizations < ActiveRecord::Migration
  def self.up
    create_table :authorizations do |t|
      t.integer :subject_id
      t.string :subject_type

      t.string :verb

      t.integer :direct_object_id
      t.string :direct_object_type
    end
    add_index :authorizations, [:subject_id, :subject_type, :verb, :direct_object_id, :direct_object_type], :unique=>true, :name=>'all_index'
    add_index :authorizations, [:subject_id, :subject_type]
    add_index :authorizations, [:direct_object_id, :direct_object_type]
  end

  def self.down
    drop_table :authorizations
  end
end
