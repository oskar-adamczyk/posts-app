# frozen_string_literal: true

class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts, id: :uuid do |t|
      t.string :content, null: false, limit: 256
      t.string :origin_ip, null: false, limit: 45
      t.string :title, null: false, limit: 256

      t.references :user, type: :uuid, index: true, foreign_key: true, null: false

      t.datetime :deleted_at
      t.timestamps null: false
    end

    add_index :posts, "lower(title)", unique: true, where: "deleted_at IS NULL"
  end
end
