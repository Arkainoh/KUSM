class CreateRsvDates < ActiveRecord::Migration
  def change
    create_table :rsv_dates do |t|
      t.string :timeStr
      t.timestamps null: false
    end
  end
end
