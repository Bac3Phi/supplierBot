class CreateInvoices < ActiveRecord::Migration[6.0]
  def change
    create_table :invoices do |t|
      t.string :po_number
      t.string :order_number
      t.string :supplier_name
      t.string :amount

      t.timestamps
    end
  end
end
