class CreateTopImages < ActiveRecord::Migration[5.0]
  def change
    create_table :top_images do |t|
      t.string :top_icon
      t.string :title
      t.string :content
      t.integer :user_id
      t.integer :top_choosed_number, default: 0
      t.timestamps
    end
  end
end