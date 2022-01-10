# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users, id: :uuid do |t|
      t.string :email, null: false, limit: 254

      t.datetime :deleted_at
      t.timestamps null: false
    end

    add_index :users, "lower(email)", unique: true, where: "deleted_at IS NULL"
  end
end
