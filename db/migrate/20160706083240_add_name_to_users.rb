class AddNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string  #예약자 (이름)
    add_column :users, :real_team, :string #소속 팀 (실제로 소속된)
    
  end
end

