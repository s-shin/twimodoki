class ChangeColumnPublicToPrivateInUsers < ActiveRecord::Migration
  def up
    rename_column(:users, :public, :private)
  end

  def down
    rename_column(:users, :private, :public)
  end
end
