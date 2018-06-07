class CreateCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :categories do |t|
      t.references :user, index: { name: 'index_categories_on_user_id' }
      t.string :name

      t.timestamps
    end
  end
end
