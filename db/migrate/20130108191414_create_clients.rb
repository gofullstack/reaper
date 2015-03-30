class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.integer :harvest_id
      t.string :name
      t.integer :highrise_id
      t.integer :cache_version
      t.string :currency
      t.boolean :active
      t.text :details
      t.string :default_invoice_timeframe
      t.string :last_invoice_kind

      t.timestamps
    end

    add_index :clients, :harvest_id
    add_index :clients, :highrise_id
  end
end
