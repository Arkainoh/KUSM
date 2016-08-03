class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|

       t.string :title
       t.string :writer_info
       t.string :writer_team
       t.string :writer_contact
       t.string :writer_time 
       t.string :content

      t.timestamps null: false
    end
  end
end
