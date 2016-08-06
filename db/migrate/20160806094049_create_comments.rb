class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :useremail
      t.string :username
      t.string :userteam
      t.string :content
      t.integer :post_id
      t.timestamps null: false
    end
  end
end
