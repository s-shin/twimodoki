class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.text :real_name
      t.text :name
      t.text :password_digest
      t.text :email

      t.timestamps
    end
  end
end
