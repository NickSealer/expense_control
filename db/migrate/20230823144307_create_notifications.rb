class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.boolean :read, default: false
      t.datetime :read_at
      t.string :message
      t.string :url
      t.belongs_to :user

      t.timestamps
    end
  end
end
