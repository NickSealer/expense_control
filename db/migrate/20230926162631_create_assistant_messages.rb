class CreateAssistantMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :assistant_messages do |t|
      t.text :request, default: ''
      t.text :message, default: ''
      t.belongs_to :user

      t.timestamps
    end
  end
end
