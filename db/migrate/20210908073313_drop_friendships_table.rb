class DropFriendshipsTable < ActiveRecord::Migration[6.0]
  def up
    drop_table :friendships
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
