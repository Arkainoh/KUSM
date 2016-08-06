class CreateRsvinfos < ActiveRecord::Migration
  def change
    
    create_table :rsvinfos do |t|
      
      t.string   :userId
      t.string   :userName
      t.string   :groupName
      t.string   :teamName
      t.string   :resDay
      t.string   :hourStr
      t.integer   :preNum
      t.integer   :totalNum
      t.integer   :monthCnt
      t.string   :regDate
      t.string   :status
      t.timestamps null: false
      
    end

  end
end
