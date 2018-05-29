class CreateLists < ActiveRecord::Migration[5.2]
  def change
    create_table :lists do |t|
      t.references :user, index: { name: 'index_lists_on_user_id' }
      t.string :name
      t.string :currency

      t.timestamps
    end
  end
end
