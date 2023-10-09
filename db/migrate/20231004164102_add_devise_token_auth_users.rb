class AddDeviseTokenAuthUsers < ActiveRecord::Migration[7.0]
  def change   
    ## Required
    add_column :users, :provider, :string, null: false, default: 'email'
    add_column :users, :uid, :string, null: false, default: ''
    ## Recoverable
    add_column :users, :allow_password_change, :boolean, default: false
    ## Confirmable
    add_column :users, :confirmation_token, :string
    add_column :users, :confirmed_at, :string
    add_column :users, :confirmation_sent_at, :string
    add_column :users, :unconfirmed_email, :string
    ## Tokens
    add_column :users, :tokens, :json

    add_index :users, :confirmation_token, unique: true
  end
end
