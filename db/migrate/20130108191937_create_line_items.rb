class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.string :kind
      t.text :description
      t.decimal :quantity, :scale => 2, :precision => 10
      t.decimal :unit_price, :scale => 2, :precision => 10
      t.decimal :amount, :scale => 2, :precision => 10
      t.boolean :taxed
      t.boolean :taxed2
      t.integer :project_id

      t.references :invoice

      t.timestamps
    end

    add_index :line_items, :project_id
  end
end
