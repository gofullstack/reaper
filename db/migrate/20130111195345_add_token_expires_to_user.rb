class AddTokenExpiresToUser < ActiveRecord::Migration
  def change
    add_column :users, :token_expires_at, :integer
    add_column :users, :token_expires, :boolean
  end
end
