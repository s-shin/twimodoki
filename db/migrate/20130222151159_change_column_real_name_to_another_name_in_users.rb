class ChangeColumnRealNameToAnotherNameInUsers < ActiveRecord::Migration
  def up
    rename_column(:users, :real_name, :another_name)
  end

  def down
    rename_column(:users, :another_name, :real_name)
  end
end
