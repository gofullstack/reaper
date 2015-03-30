class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :subdomain
      t.string :login
      t.string :password
      t.boolean :use_ssl

      t.timestamps
    end
  end
end
