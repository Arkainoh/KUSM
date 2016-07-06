class CreateRsvinfos < ActiveRecord::Migration
  def change
    create_table :rsvinfos do |t|

      t.timestamps null: false
    end
  end
end
