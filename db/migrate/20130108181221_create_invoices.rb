class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.text :subject
      t.string :number
      t.date :issued_at
      t.date :due_at
      t.string :due_at_human_format
      t.decimal :due_amount, :scale => 2, :precision => 10
      t.text :notes
      t.integer :recurring_invoice_id
      t.date :period_start
      t.date :period_end
      t.decimal :discount, :scale => 2, :precision => 10
      t.decimal :discount_amount, :scale => 2, :precision => 10
      t.string :client_key
      t.decimal :amount, :scale => 2, :precision => 10
      t.decimal :tax, :scale => 2, :precision => 10
      t.decimal :tax2, :scale => 2, :precision => 10
      t.decimal :tax_amount, :scale => 2, :precision => 10
      t.decimal :tax2_amount, :scale => 2, :precision => 10
      t.integer :estimate_id
      t.string :purchase_order
      t.integer :retainer_id
      t.string :currency
      t.string :state
      t.integer :harvest_id

      t.references :user
      t.references :client

      t.timestamps
    end

    add_index :invoices, :recurring_invoice_id
    add_index :invoices, :estimate_id
    add_index :invoices, :retainer_id
    add_index :invoices, :harvest_id
  end
end
