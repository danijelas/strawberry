class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.references :list, index: { name: 'index_items_on_list_id' }
      t.references :category, null: true
      t.string :name
      t.string :description
      t.decimal :price, precision: 10, scale: 2, default: 0.00
      t.boolean :done, default: false

      t.timestamps
    end
  end
end
