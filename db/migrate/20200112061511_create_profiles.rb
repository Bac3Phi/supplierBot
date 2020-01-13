class CreateProfiles < ActiveRecord::Migration[6.0]
  def change
    create_table :profiles do |t|
      t.string :company_name
      t.string :name
      t.string :email
      t.string :sub_email
      t.integer :kind

      t.timestamps
    end
  end
end
