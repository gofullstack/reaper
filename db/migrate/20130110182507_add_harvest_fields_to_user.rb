class AddHarvestFieldsToUser < ActiveRecord::Migration
  def up
    add_column :users, :access_token, :string
    add_column :users, :refresh_token, :string
    add_column :users, :email, :string

    remove_column :users, :password
    remove_column :users, :use_ssl
    remove_column :users, :subdomain
    remove_column :users, :login
  end

  def down
    remove_column :users, :access_token
    remove_column :users, :refresh_token
    remove_column :users, :email

    add_column :users, :password, :string
    add_column :users, :use_ssl, :boolean
    add_column :users, :subdomain, :string
    add_column :users, :login, :string
  end
end
